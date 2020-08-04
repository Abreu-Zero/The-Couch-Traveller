//
//  FlickrClient.swift
//  TheCouchTraveller
//
//  Created by Henrique Abreu on 03/08/2020.
//  Copyright © 2020 Henrique Abreu. All rights reserved.
//

import Foundation
import UIKit

class FlickrClient{
        
    var url: String = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=7eb8d8258cca4594b5a50ae10b735ed2"
    
    func buildURL(latitude: Double, longitude: Double) -> String{
 
        return self.url +
            "&lat=\(String(latitude))" +
            "&lon=\(String(longitude))" +
            "&radius=10" +
            "&per_page=20" +
            "&page=0" +
        "&format=json&nojsoncallback=1&extras=url_m"
    }
    
    
    //this request return a [PhotoR], that should have all the details to be used in the PhotoAlbumVC
    
    class func requestImageFile(url: URL, completionHandler: @escaping ([PhotoR]?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            do{
                let decoder = JSONDecoder()
                let photos = try decoder.decode(Photos.self, from: data)
                completionHandler(photos.photo, nil)
            }catch{
                completionHandler(nil, error)
            }
                    
        })
        task.resume()
    }
}
