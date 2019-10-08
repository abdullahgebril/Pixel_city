//
//  ViewController.swift
//  Pixel_City
//
//  Created by Abdullah Gebreil on 2/6/1441 AH.
//  Copyright © 1441 AH Abdullah Gebreil. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
       mapView.delegate = self
    }

    @IBAction func centerMapBtnClicked(_ sender: Any) {
    }
    
}

extension MapVC: MKMapViewDelegate {
    
    
}
