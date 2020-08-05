//
//  PhotoAlbumViewController.swift
//  TheCouchTraveller
//
//  Created by Henrique Abreu on 03/08/2020.
//  Copyright © 2020 Henrique Abreu. All rights reserved.
//

import UIKit
import CoreData

class PhotoAlbumViewController: UICollectionViewController {

    var photos: [Photo] = []
    var dataController: DataController?
    var location: Location!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(location ?? "not found")
        
        //FIXME: discover why the hell the pictures are not being shown correctly
        loadSavedImages()
    }
    
    func downloadAlbum(){
        let url = FlickrClient.buildURL(latitude: location.latitude, longitude: location.longitude)
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
                    let newPhoto = Photo(context: self.dataController!.viewContext)
                    newPhoto.img = photoImg.pngData()
                    newPhoto.title = p.title
                    newPhoto.location = self.location
                    self.photos.append(newPhoto)
                    try? self.dataController?.viewContext.save()
                }
                //TODO: filter the private photos?
            }
            DispatchQueue.main.async {
                    self.collectionView.reloadData()
                   }
        }
    }
    
    func loadSavedImages(){
        
        let predicate = NSPredicate(format: "location == %@", location)
        let fetchRequest : NSFetchRequest<Photo> = Photo.fetchRequest()
        fetchRequest.predicate = predicate
        
        guard let result = try? dataController?.viewContext.fetch(fetchRequest) else{return}
        photos = result
        print("saved data count:" + String(photos.count))
        
        if photos.count == 0{
            downloadAlbum()
        } else{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
           return 1
       }
       
       override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return photos.count
       }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //sets the cell using photo data

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        let photo = self.photos[indexPath.row]
        guard let data = photo.img else {
            fatalError("ERROR WHILE CONVERTING DATA TO UIIMAGE")
        }
        let img = UIImage(data: data, scale:1.0)
        cell.imageView.image = img
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
        try? dataController?.viewContext.save()
    }
}
