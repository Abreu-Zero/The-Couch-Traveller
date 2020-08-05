//
//  PhotoAlbumViewController.swift
//  TheCouchTraveller
//
//  Created by Henrique Abreu on 03/08/2020.
//  Copyright © 2020 Henrique Abreu. All rights reserved.
//

import UIKit

class PhotoAlbumViewController: UICollectionViewController {

    var latitude: Double?
    var longitude: Double?
    var photos: [Photo] = []
    var downloadedPhotos: [UIImage] = []
    var dataController: DataController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(latitude ?? "not found")
        
        //FIXME: discover why the hell the pictures are not being shown correctly
        loadSavedImages()
    }
    
    func downloadAlbum(){

        guard let latitude = latitude else {
            print("ERROR: latitude not found")
            return
        }
        guard let longitude = longitude else {
            print("ERROR: longitude not found")
            return
        }
        let url = FlickrClient.buildURL(latitude: latitude, longitude: longitude)
        FlickrClient.requestPhotoAlbum(url: url) { (data, error) in
        guard let data = data else{
            print(error!)
            return
            }
            for p in data{
                FlickrClient.requestImageFile(url: URL(string: p.url)!) { (photoImg, error) in
                    guard let photoImg = photoImg else{
                        print(error!)
                        return
                    }
                    self.downloadedPhotos.append(photoImg)
                    print("photo count: " + String(self.downloadedPhotos.count))
                    let newPhoto = Photo(context: self.dataController!.viewContext)
                    newPhoto.img = photoImg.pngData()
                    newPhoto.title = p.title
                    self.photos.append(newPhoto)
                    do{
                        try self.dataController?.viewContext.save()}
                    catch{
                        print("ERROR: error while saving image to model")
                        return
                    }

                }
                
                //TODO: filter the private photos?
            }
            
            DispatchQueue.main.async {
                    self.collectionView.reloadData()
                   }
        }
    }
    
    func loadSavedImages(){
        downloadAlbum()
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
           return 1
       }
       
       override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return downloadedPhotos.count
       }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //sets the cell using photo data

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        let photo = self.downloadedPhotos[indexPath.row]
        cell.imageView.image = photo
        return cell
    }
    
    // MARK: segue funcs
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "toPhoto"{
      
             if let cell = sender as? UICollectionViewCell{
                
                let indexPath = self.collectionView!.indexPath(for: cell)
                let photo = self.photos[indexPath!.row]
                let viewDestination = segue.destination as! DetailsViewController

                 
             }
             
         }
        
        
     }
    
    @IBAction func refreshData(_ sender: Any) {
        self.collectionView.reloadData()
    }
}
