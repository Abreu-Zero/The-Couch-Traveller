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
    var photoAlbum: [PhotoR] = []
    var dataController: DataController?
    var location: Location!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSavedImages()
    }
    
    //MARK: handler functions
    
    func downloadAlbum(){
        //func handles the API download and populates the array. Is called if the user
        //dont have saved photos on the device
        let url = FlickrClient.buildURL(latitude: location.latitude, longitude: location.longitude)
        FlickrClient.requestPhotoAlbum(url: url) { (data, error) in
        guard let data = data else{
            print(error!)
            return
            }
            self.photoAlbum = data
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
        //func check for saved photos, if the user dont have downloaded them yet, it asks
        //for the download and populates the array
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
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
       //MARK: CollectionView Functions
    
       override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if photos.count >= photoAlbum.count{
            return photos.count
        } else{
            return photoAlbum.count

        }
       }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //sets the cell using photo data
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        cell.imageView.image = UIImage(named: "placeholder")
        if photos.count > 0{
            let photo = self.photos[indexPath.row]
            guard let data = photo.img else {
                fatalError("ERROR WHILE CONVERTING DATA TO UIIMAGE")
            }
            let img = UIImage(data: data, scale:1.0)
            DispatchQueue.main.async {
                cell.imageView.image = img
            }
        }
        
        return cell
    }
    
    // MARK: segue funcs
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if let cell = sender as? UICollectionViewCell{
            let indexPath = self.collectionView!.indexPath(for: cell)
            let photo = self.photos[indexPath!.row]
            let viewDestination = segue.destination as! DetailsViewController
            viewDestination.photo = photo
         }
        
        
     }
    
    //MARK: the refresher
    
    @IBAction func refreshData(_ sender: Any) {
        self.collectionView.reloadData()
        try? dataController?.viewContext.save()
        //TODO: Implement new random download
    }
}
