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
    
    
    var pinsEnabled = false
    
    var pizzas: [MKMapItem] = []
    var currentLocation: CLLocation!
    let location = CLLocationCoordinate2D()
    
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
        let showButton = UIButton(type: .detailDisclosure)
        if annotation.isEqual(zaMap.userLocation)  {
            return nil
            
        }
        let pin = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        let pinImage = UIImage(named: "pepperoni")
        pin.image = pinImage
        pin.canShowCallout = true
        pin.rightCalloutAccessoryView = showButton
       
        
        
        
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
            for landmark in response.mapItems {
                self.pizzas.append(landmark)
                let point = MKPointAnnotation()
                point.title = landmark.name
                point.coordinate = landmark.placemark.coordinate
                self.zaMap.addAnnotation(point)
            }
        }
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("I am a table")
        var initialRegion = MKCoordinateRegion(center: zaMap.centerCoordinate, span: zaMap.region.span)
        let button = control as! UIButton
        if button.buttonType == .detailDisclosure {
            mapView.setRegion(initialRegion, animated: true)
            var currentMapItem = MKMapItem()
            if let name = view.annotation?.title, let pizzaName = name {
                for mapItem in pizzas {
                    if mapItem.name == pizzaName {
                        currentMapItem = mapItem
                    }
                }
            }
            guard let placelocate1 = currentMapItem.placemark.thoroughfare, let placelocate2 = currentMapItem.placemark.subThoroughfare, let phonenumber = currentMapItem.phoneNumber else { return }
            print("I am a chair")
            present(placelocate1 + " ", placeTwo: placelocate2 + " ", number: phonenumber)

            
            return
        }
       
      

    }
    
    func present(_ placeOne: String, placeTwo: String, number: String) {
        let locationAlert = UIAlertController(title: placeOne + placeTwo + number, message: nil, preferredStyle: .alert)
        let locationAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: nil)
        locationAlert.addAction(locationAction)
        present(locationAlert, animated: true, completion: nil)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      currentLocation = locations[0]
    }
}

