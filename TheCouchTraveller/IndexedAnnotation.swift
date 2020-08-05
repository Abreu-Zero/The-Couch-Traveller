//
//  IndexedAnnotation.swift
//  TheCouchTraveller
//
//  Created by Henrique Abreu on 05/08/2020.
//  Copyright © 2020 Henrique Abreu. All rights reserved.
//

import Foundation
import MapKit

class IndexedAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var index: Int?
    var subtitle: String?
    var extraTitle: String?
    
    init(coordinate:CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
