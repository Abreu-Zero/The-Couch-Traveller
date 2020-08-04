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
            FlickrClient.requestPhotoAlbum(url: url) { (data, error) in
            guard let data = data else{
                print(error!)
                return
                }
                for p in data{
                    let newPhoto = Photo()
                    newPhoto.url = URL(string: p.url)
                    newPhoto.title = p.title
                }
            }
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //sets the cell using photo data

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        let photo = self.photos[indexPath.row].url

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
    
}
