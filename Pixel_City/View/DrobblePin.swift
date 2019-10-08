//
//  DrobblePin.swift
//  Pixel_City
//
//  Created by Abdullah Gebreil on 2/7/1441 AH.
//  Copyright © 1441 AH Abdullah Gebreil. All rights reserved.
//

import UIKit
import MapKit
class DrobblePin: NSObject , MKAnnotation {
       dynamic var coordinate: CLLocationCoordinate2D
    var identifer:String
    init(coordinate: CLLocationCoordinate2D,identifer:String) {
        self.coordinate = coordinate
        self.identifer = identifer
    }
}
