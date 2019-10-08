//
//  Constant.swift
//  Pixel_City
//
//  Created by Abdullah Gebreil on 2/7/1441 AH.
//  Copyright © 1441 AH Abdullah Gebreil. All rights reserved.
//

import Foundation
 let APIKEY = "b5c05482320a5d423260c1e123d590e2"

func flickrURL(AndAnnotion annotion : DrobblePin ,AndNumberOfPage number: Int)-> String {
    let minLat = annotion.coordinate.latitude - 1
    let maxLat = annotion.coordinate.latitude + 1
    let minLon = annotion.coordinate.longitude - 1
    let maxLon = annotion.coordinate.longitude + 1
    let url = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(APIKEY)&bbox=\(minLon)%2C\(minLat)%2C\(maxLon)%2C\(maxLat)&radius=1&radius_units=mi&per_page=\(number)&format=json&nojsoncallback=1"
    
    
    
    
//"https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(APIKEY)&lat=\(annotion.coordinate.latitude)&lon=\(annotion.coordinate.longitude)&radius=1&radius_units=mi&per_page=\(number)&format=json&nojsoncallback=1"


return url 
}
