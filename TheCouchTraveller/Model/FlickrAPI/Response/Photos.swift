//
//  Photos.swift
//  TheCouchTraveller
//
//  Created by Henrique Abreu on 03/08/2020.
//  Copyright © 2020 Henrique Abreu. All rights reserved.
//

import Foundation

struct Photos: Codable{
    
    let page: Int
    let pages: Int
    let perpage: Int
    let total : Int
    let photo: [PhotoR]
}

struct PhotoR: Codable{
    
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let ispublic: Bool
    let isfriend: Bool
    let isfamily: Bool
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
