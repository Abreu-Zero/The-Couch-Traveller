//
//  FlickrClient.swift
//  TheCouchTraveller
//
//  Created by Henrique Abreu on 03/08/2020.
//  Copyright © 2020 Henrique Abreu. All rights reserved.
//

import Foundation

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
    
    //TODO: add get request for the location func and dowload photos for location func to PhotoAlbumVC handle
    //TODO: Implement parser for EVERYTHING
}
