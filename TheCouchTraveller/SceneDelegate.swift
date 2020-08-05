//
//  SceneDelegate.swift
//  TheCouchTraveller
//
//  Created by Henrique Abreu on 03/08/2020.
//  Copyright © 2020 Henrique Abreu. All rights reserved.
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let dataController = DataController(modelName: "TheCouchTraveller")



    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        dataController.load()

        let navigationController = window?.rootViewController as! UINavigationController
        let mapVC = navigationController.topViewController as! MapViewController
        mapVC.dataController = dataController
        guard let _ = (scene as? UIWindowScene) else { return }
    }

}

