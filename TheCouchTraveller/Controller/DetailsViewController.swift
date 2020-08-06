//
//  DetailsViewController.swift
//  TheCouchTraveller
//
//  Created by Henrique Abreu on 04/08/2020.
//  Copyright © 2020 Henrique Abreu. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let img = UIImage(data: photo!.img!, scale:1.0)
        imageView.image = img
        titleLabel.text = photo?.title
  
    }
    var photo: Photo?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
}
