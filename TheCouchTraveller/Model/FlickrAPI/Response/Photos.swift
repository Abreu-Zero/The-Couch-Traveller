//
//  Photos.swift
//  TheCouchTraveller
//
//  Created by Henrique Abreu on 03/08/2020.
//  Copyright © 2020 Henrique Abreu. All rights reserved.
//

import Foundation
struct fResults: Codable{
    
    let photos: Photos
}
struct Photos: Codable{
    
    let page: Int
    let pages: Int
    let perpage: Int
    let total : String
    let photo: [PhotoR]
    
    enum CodingKeys: String, CodingKey{
        case page
        case pages
        case perpage
        case total
        case photo
    }
}

struct PhotoR: Codable{
    
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let ispublic: Int
    let isfriend: Int
    let isfamily: Int
    let url: String
    let height: Double
    let width: Double
    
    enum CodingKeys: String, CodingKey {
            case id
            case owner
            case secret
            case server
            case farm
            case title
            case ispublic
            case isfriend
            case isfamily
            case url = "url_m"
            case height = "height_m"
            case width = "width_m"
       }
}
