//
//  ViewController.swift
//  `Za Hunter
//
//  Created by Kyle Chung on 4/3/19.
//  Copyright © 2019 Kyle Chung. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet var zaMap: MKMapView!
    
    var pizzas: [MKMapItem] = []
    
    var currentLocation: CLLocation!
    
    let location = CLLocationCoordinate2D()
    
    
    
    let zoomButton = UIButton(type: .detailDisclosure)
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        zaMap.delegate = self
        zaMap.showsUserLocation = true
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        zaMap.showsUserLocation = true
    }
   
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isEqual(zaMap.userLocation)  {
            return nil
        }
        
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        pin.canShowCallout = true
        pin.rightCalloutAccessoryView = zoomButton
        return pin
    }
    
    @IBAction func zoomPressed(_ sender: Any) {
        let center = currentLocation.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: center
            , span: span)
        
        
        zaMap.setRegion(region, animated: true)
        
    }
    @IBAction func search(_ sender: Any) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "pizza"
        let around = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        request.region = MKCoordinateRegion(center: currentLocation.coordinate, span: around)
        let lookUP = MKLocalSearch(request: request)
        lookUP.start { (response, error) in
             guard let response = response else { return }
            for hello in response.mapItems {
                
            }
        }
       
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        var initialRegion = MKCoordinateRegion(center: zaMap.centerCoordinate, span: zaMap.region.span)
        
        let button = control as! UIButton
        if button.buttonType == .detailDisclosure {
            mapView.setRegion(initialRegion, animated: true)
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      currentLocation = locations[0]
        
    }
   
    

}

