//
//  services.swift
//  Pixel_City
//
//  Created by Abdullah Gebreil on 2/7/1441 AH.
//  Copyright © 1441 AH Abdullah Gebreil. All rights reserved.
//

import Foundation
import Alamofire

class Services {
    
    var urlArray = [String]()

    typealias completionHandler  = (_ handler:Bool) -> ()
   
    
    
 
    
    func retrieveUrls(annotion : DrobblePin ,andNumberOfPages number: Int,completion: @escaping completionHandler) {
        
      
        
        Alamofire.request(url).responseJSON { (response) in
            print(response)
            //guard let json = response.result.value as? [String:Any] else {return}
        }
    
    
}
}
