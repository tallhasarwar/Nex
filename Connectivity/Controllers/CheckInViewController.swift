//
//  CheckInViewController.swift
//  Connectivity
//
//  Created by Danial Zahid on 02/10/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class CheckInViewController: BaseViewController, GMSMapViewDelegate {

    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    @IBOutlet weak var viewForMap: UIView!
    var mapView : GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    
    // An array to hold the list of likely places.
    var likelyPlaces: [GooglePlace] = []
    
    // The currently selected place.
    var selectedPlace: GooglePlace?
    
    // A default location to use when location permission is not granted.
    var defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)

    // Update the map once the user has made their selection.
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
        // Clear the map.
        mapView.clear()
        
    }
    
    // Present the Autocomplete view controller when the button is pressed.
    @IBAction func autocompleteClicked(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Set a filter to return only addresses.
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        autocompleteController.autocompleteFilter = filter
        
        present(autocompleteController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "Where are you?"
        
        if ApplicationManager.sharedInstance.user.email == nil {
            SVProgressHUD.show()
            RequestManager.getUser(successBlock: { (response) in
                SVProgressHUD.dismiss()
                let user = User(dictionary: response)
                ApplicationManager.sharedInstance.user = user
            }, failureBlock: { (error) in
                SVProgressHUD.showError(withStatus: error)
            })
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupLocation() {
        // Initialize the location manager.
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 100
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()

        // Create a map.
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: viewForMap.bounds, camera: camera)
        mapView.camera = camera
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        mapView.settings.scrollGestures = false
        // Add the map to the view, hide it until we&#39;ve got a location update.
        viewForMap.addSubview(mapView)
        mapView.delegate = self
        
        listLikelyPlaces()
    }
    
    // Populate the array with the list of likely places.
    func listLikelyPlaces() {
        
        var params = [String: AnyObject]()
        let coordinate = self.mapView.getCenterCoordinate()
        defaultLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
//        params["radius"] = min(self.mapView.getRadius(), 1500) as AnyObject
        params["location"] = "\(coordinate.latitude),\(coordinate.longitude)" as AnyObject
        params["key"] = "AIzaSyByRuCinleTQVigifuFU0-AOqvnEFieEYo" as AnyObject
        params["rankby"] = "distance" as AnyObject
        params["keyword"] = "establishment" as AnyObject
        
        RequestManager.getLocations(param: params, successBlock: { (response) in
            self.likelyPlaces.removeAll()
            for object in response {
                self.likelyPlaces.append(GooglePlace(dictionary: object))
            }
            self.tableView.reloadData()
        }) { (error) in
            
        }
        
    }
    

    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        listLikelyPlaces()
    }
    
}

// Delegates to handle events for the location manager.
extension CheckInViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        
        
        mapView.isHidden = false
        mapView.camera = camera
        
        mapView.animate(to: camera)
        defaultLocation = location
        
//        locationManager.stopUpdatingLocation()
        
        listLikelyPlaces()
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

extension CheckInViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likelyPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CheckinTableViewCell.identifier) as! CheckinTableViewCell
        cell.mainLabel.text = likelyPlaces[indexPath.row].name
        cell.addressLabel.text = likelyPlaces[indexPath.row].vicinity
        
        let distance = self.mapView.getDistanceToCoordinates(coordinates: likelyPlaces[indexPath.row].coordinates!)
        
        cell.distanceLabel.text = "\(distance)m"
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.openPlace(place: likelyPlaces[indexPath.row])
    }
    
    func openPlace(place: GooglePlace) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: LocationDetailsViewController.storyboardID) as! LocationDetailsViewController
        vc.place = place
        self.navigationController?.show(vc, sender: nil)
    }
    
}

extension CheckInViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Print place info to the console.
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress ?? "")")
        print("Place attributions: \(place.attributions ?? NSAttributedString(string: ""))")
        
        // TODO: Add code to get address components from the selected place.
        
        // Close the autocomplete widget.
        dismiss(animated: true, completion: nil)
//        self.openPlace(place: place)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Show the network activity indicator.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    // Hide the network activity indicator.
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

extension GMSMapView {
    func getCenterCoordinate() -> CLLocationCoordinate2D {
        let centerPoint = self.center
        let centerCoordinate = self.projection.coordinate(for: centerPoint)
        return centerCoordinate
    }
    
    func getTopCenterCoordinate() -> CLLocationCoordinate2D {
        // to get coordinate from CGPoint of your map
        let topCenterCoor = self.convert(CGPoint(x: self.frame.size.width, y: 0), from: self)
        let point = self.projection.coordinate(for: topCenterCoor)
        return point
    }
    
    func getRadius() -> Int {
        let centerCoordinate = getCenterCoordinate()
        let centerLocation = CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
        let topCenterCoordinate = self.getTopCenterCoordinate()
        let topCenterLocation = CLLocation(latitude: topCenterCoordinate.latitude, longitude: topCenterCoordinate.longitude)
        let radius = CLLocationDistance(centerLocation.distance(from: topCenterLocation))
        return Int(round(radius))
    }
    
    func getDistanceToCoordinates(coordinates: CLLocationCoordinate2D) -> Int {
        let centerCoordinate = getCenterCoordinate()
        let centerLocation = CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
        let topCenterLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        let radius = CLLocationDistance(centerLocation.distance(from: topCenterLocation))
        return Int(round(radius))
    }
}
