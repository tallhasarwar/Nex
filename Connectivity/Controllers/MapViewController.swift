//
//  MapViewController.swift
//  Connectivity
//
//  Created by Danial Zahid on 4/19/18.
//  Copyright © 2018 Danial Zahid. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
    
    static let storyboardID = "mapViewController"
    
    @IBOutlet weak var viewForMap: UIView!
    var mapView : GMSMapView!
    var mapMarker: GMSMarker?
    
    var zoomLevel: Float = 15.0
    var defaultLocation = CLLocationCoordinate2D(latitude: -33.869405, longitude: 151.199)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Location"
        
        mapView = GMSMapView(frame: viewForMap.bounds)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
//                mapView.settings.scrollGestures = false
//                mapView.isUserInteractionEnabled = false
        viewForMap.addSubview(mapView)
//        mapView.delegate = self
        
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.latitude,
                                              longitude: defaultLocation.longitude,
                                              zoom: zoomLevel)
        
        
        mapView.isHidden = false
        mapView.camera = camera
        
        mapView.animate(to: camera)
        mapMarker = GMSMarker()
        mapMarker?.map = mapView
        mapMarker?.appearAnimation = GMSMarkerAnimation.pop
        mapMarker?.position = defaultLocation

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
