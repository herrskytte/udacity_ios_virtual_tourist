//
//  AlbumViewController.swift
//  Virtual Tourist
//
//  Created by Frederik Skytte on 31/01/2019.
//  Copyright © 2019 Frederik Skytte. All rights reserved.
//

import UIKit
import MapKit

class AlbumViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    /// The pin for the album in this view
    var currentPin: Pin!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showLocationPin()
    }
    
    
    func showLocationPin() {
        let coordinate = CLLocationCoordinate2D(latitude: currentPin.latitude, longitude: currentPin.longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.addAnnotation(annotation)
        self.mapView.setCenter(coordinate, animated: true)
    }
}

