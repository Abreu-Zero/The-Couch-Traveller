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
    var dataController: DataController?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func deletePhoto(_ sender: Any) {
        presentNewNotebookAlert()
    }
    
    func nowReallyDeletePhoto(){
        print("I WILL DELETE IT I SWEAR")
        dataController?.viewContext.delete(photo!)
        try? dataController?.viewContext.save()
        _ = navigationController?.popViewController(animated: true)
    }
    
    func presentNewNotebookAlert() {
    let alert = UIAlertController(title: "Delete Photo", message: "Are you sure you want to delete this photo?", preferredStyle: .alert)

    // Create actions
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] action in
        self!.nowReallyDeletePhoto()
    }
        
    alert.addAction(cancelAction)
        alert.addAction(deleteAction)
    present(alert, animated: true, completion: nil)

        
    }
}
