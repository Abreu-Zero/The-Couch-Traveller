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
    
    //builds the URL for the GET request, using INt.random
    // to get a different page every request
    
    class func buildURL(latitude: Double, longitude: Double) -> URL{
        let randomPage = Int.random(in: 0..<25)
        let pageString = "&page=0\(randomPage)"
        let toReturn =  "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=7eb8d8258cca4594b5a50ae10b735ed2" +
            "&lat=\(String(latitude))" +
            "&lon=\(String(longitude))" +
            "&radius=15" +
            "&per_page=50" +
            pageString +
            "&format=json&nojsoncallback=1&extras=url_m"
        
        return URL(string: toReturn)!
    }
    
    
    //this request return a [PhotoR], that should have all the details to be used in the PhotoAlbumVC
    
    class func requestPhotoAlbum(url: URL, completionHandler: @escaping ([PhotoR]?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            do{
                let decoder = JSONDecoder()
                let result = try decoder.decode(fResults.self, from: data)
                let photos = result.photos
                completionHandler(photos.photo, nil)
            }catch{
                completionHandler(nil, error)
            }
                    
        })
        task.resume()
    }
    
    //this request uses the previous response's URL to download the final image
    
    class func requestImageFile(url: URL, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            let downloadedImage = UIImage(data: data)
            completionHandler(downloadedImage, nil)
        })
        task.resume()
    }
    
    
}
