//
//  ViewController.swift
//  Pixel_City
//
//  Created by Abdullah Gebreil on 2/6/1441 AH.
//  Copyright © 1441 AH Abdullah Gebreil. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire
import AlamofireImage

class MapVC: UIViewController ,UIGestureRecognizerDelegate {
 
    //Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var pullUpViewHieght: NSLayoutConstraint!
    @IBOutlet weak var pullUp: UIView!
    
    
    
    
    // Varaibles
    var locationManager = CLLocationManager()
    let authorizatioStatus = CLLocationManager.authorizationStatus()
    let regionRaduis: Double = 1000
    var spinner: UIActivityIndicatorView?
    var prograsslabl: UILabel?
    var collectionview:UICollectionView?
    var flowlayout = UICollectionViewFlowLayout()
    let screensize  = UIScreen.main.bounds
    var arrayOfUrl = [String]()
    var ImagesArray = [UIImage]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
       mapView.delegate = self
        locationManager.delegate = self
        configureAuthorization()
        addDoubleTap()
        setCollectioView()
    
    }
    func setCollectioView(){
        collectionview = UICollectionView(frame: view.bounds, collectionViewLayout: flowlayout)
        collectionview?.register(PhotosCell.self, forCellWithReuseIdentifier: "PhotosCell")
        collectionview?.delegate = self
        collectionview?.dataSource = self
        collectionview?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        pullUp.addSubview(collectionview!)
       
    }

    
    func addDoubleTap() {
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(addPint(sender:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self
        mapView.addGestureRecognizer(doubleTap)
    }
    
    @objc func addPint(sender: UITapGestureRecognizer) {
        
        removeAnnotions()
        removeSpinner()
        cancellAllSession()
        arrayOfUrl = []
        ImagesArray = []
        collectionview?.reloadData()
        
        animatePullUpView()
        addSwipe()
        addspinner()
        
        let touchPoint = sender.location(in: mapView)
        let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let annotion = DrobblePin(coordinate: coordinate, identifer: "Pin")
        mapView.addAnnotation(annotion)
        let coordianteRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRaduis * 2.0, longitudinalMeters: regionRaduis * 2.0)
        mapView.setRegion(coordianteRegion, animated: true)
        getUrlArray(ForAnnotion: annotion) { (finished) in
            if finished {
                self.getPhotosFromUrl(completionHandler: { (finished) in
                    if finished {
                        self.removeSpinner()
                        self.collectionview?.reloadData()
                    }
                    
                }
                )}
        }
    }
    
    func getUrlArray(ForAnnotion annotion : DrobblePin , completionHandler : @escaping (_ status: Bool)-> ()) {
        
        Alamofire.request(flickrURL(AndAnnotion: annotion, AndNumberOfPage: 40)).responseJSON { (response) in
         
            guard let json = response.result.value as? [String: Any] else {return}
            let photos = json["photos"] as! [String:Any]
            let photoarray = photos["photo"] as![[String:Any]]
            for photo in photoarray {
            
              let urlImage = "https://farm\(photo["farm"]!).staticflickr.com/\(photo["server"]!)/\(photo["id"]!)_\(photo["secret"]!)_n_d.jpg"
                self.arrayOfUrl.append(urlImage)
            }
            completionHandler(true)
        }
    }
    
    func getPhotosFromUrl(completionHandler: @escaping (_ status : Bool)->()) {
     
        for url in arrayOfUrl {
           
            Alamofire.request(url).responseImage { (response) in
                
                let photoData = try? Data(contentsOf:URL(string: url)!)
       
                
                let image = UIImage(data: photoData!)
                self.ImagesArray.append(image!)
                
            }
         
            
    }
         completionHandler(true)
        
    }
    
    
    func cancellAllSession() {
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, DwonloadData) in
            
            for task in sessionDataTask {
                task.cancel()
            }
            for task in uploadData {
                task.cancel()
            }

            for task in DwonloadData {
                task.cancel()
            }

        }
    }
    
    func removeAnnotions () {
        
        for annotion in mapView.annotations {
            mapView.removeAnnotation(annotion)
        }
    }
    
    
    func animatePullUpView() {
        pullUpViewHieght.constant = 300
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    
    func addSwipe() {
        
        let swipe = UISwipeGestureRecognizer(target: self, action:#selector( animatedDwon))
        swipe.direction = .down
        pullUp.addGestureRecognizer(swipe)
    }
    
    @objc func animatedDwon() {
        cancellAllSession()
        pullUpViewHieght.constant = 0
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    func addspinner() {

        spinner = UIActivityIndicatorView(style:.whiteLarge)
        spinner?.center = CGPoint(x: screensize.width / 2 - (spinner?.frame.width)! / 2, y: 150)

        spinner?.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        spinner?.startAnimating()
        collectionview!.addSubview(spinner!)
    }
    
    func removeSpinner(){
        if spinner != nil {
            spinner?.removeFromSuperview()
        }
    }
    
    
    @IBAction func centerMapBtnClicked(_ sender: Any) {
        if authorizatioStatus ==  .authorizedAlways || authorizatioStatus == .authorizedWhenInUse {
            centerOnUserLocation()
            
        }
    }
  

}

extension MapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        let pinAnnotion = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
        pinAnnotion.pinTintColor = #colorLiteral(red: 0.2274509804, green: 0.2666666667, blue: 0.3607843137, alpha: 1)
        pinAnnotion.animatesDrop = true
        return pinAnnotion
    }
    func centerOnUserLocation() {
        guard let cooridate = locationManager.location?.coordinate else{return}
        let coordinateRegion = MKCoordinateRegion(center: cooridate, latitudinalMeters: regionRaduis * 2.0 , longitudinalMeters: regionRaduis * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
}
extension MapVC: CLLocationManagerDelegate {
    
    func configureAuthorization() {
        if authorizatioStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }else {
            return
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        centerOnUserLocation()
    }
}

extension MapVC : UICollectionViewDataSource , UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ImagesArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =  collectionview?.dequeueReusableCell(withReuseIdentifier: "PhotosCell", for: indexPath) as? PhotosCell else {return UICollectionViewCell()}
        var photoFromIndexPath = ImagesArray[indexPath.row]
        let image = UIImageView(image: photoFromIndexPath)
        cell.addSubview(image)
        return cell
    }
}
