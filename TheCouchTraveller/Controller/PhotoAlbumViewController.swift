//
//  PhotoAlbumViewController.swift
//  TheCouchTraveller
//
//  Created by Henrique Abreu on 03/08/2020.
//  Copyright © 2020 Henrique Abreu. All rights reserved.
//

import UIKit

class PhotoAlbumViewController: UICollectionViewController {

    var location: Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(location ?? "not found")

    }
    

   //TODO: implement handlers for photo downloads and UI updates

}
