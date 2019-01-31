//
//  ViewController.swift
//  Virtual Tourist
//
//  Created by Frederik Skytte on 31/01/2019.
//  Copyright © 2019 Frederik Skytte. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Generate long-press UIGestureRecognizer.
        let myLongPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
        myLongPress.addTarget(self, action: #selector(longPressToDropPin(_:)))
        
        // Added UIGestureRecognizer to MapView.
        mapView.addGestureRecognizer(myLongPress)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showLocationPins()
    }
    
    
    func showLocationPins(){
        let fetchRequest:NSFetchRequest<Pin> = Pin.fetchRequest()

        do {
            let pins = try dataController.viewContext.fetch(fetchRequest)
            
            var annotations = [MKPointAnnotation]()
            
            for pin in pins {
                
                let lat = CLLocationDegrees(pin.latitude)
                let lon = CLLocationDegrees(pin.longitude)
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotations.append(annotation)
            }
            
            // When the array is complete, we reset the annotations for the map.
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotations(annotations)
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    // A method called when long press is detected.
    @objc private func longPressToDropPin(_ sender: UILongPressGestureRecognizer) {
        // Do not generate pins many times during long press.
        if sender.state != UIGestureRecognizer.State.began {
            return
        }
        
        // Get the coordinates of the point that was pressed long.
        let location = sender.location(in: self.mapView)
        
        // Convert location to CLLocationCoordinate2D.
        let newCoordinate: CLLocationCoordinate2D = self.mapView.convert(location, toCoordinateFrom: self.mapView)
        
        // Save a new pin
        let newPin = Pin(context: dataController.viewContext)
        newPin.latitude = newCoordinate.latitude
        newPin.longitude = newCoordinate.longitude
        try? dataController.viewContext.save()
        
        // Added pins to MapView.
        self.showLocationPins()
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
}
