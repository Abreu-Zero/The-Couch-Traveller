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
    var photos: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(latitude ?? "not found")
        

    }
    
    func loadAlbum(){
        if photos.count == 0 {
            guard let latitude = latitude else {
                print("ERROR: latitude not found")
                return
            }
            guard let longitude = longitude else {
                print("ERROR: longitude not found")
                return
            }
            let url = FlickrClient.buildURL(latitude: latitude, longitude: longitude)
            FlickrClient.requestImageFile(url: url) { (data, error) in
            guard let data = data else{
                print(error!)
                return
            }
                
        }
    }
    
    // MARK: col funcs
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //sets the cell using photo data

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        let photo = self.photos[indexPath.row]

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
    

   //TODO: implement handlers for photo downloads and UI updates

}
