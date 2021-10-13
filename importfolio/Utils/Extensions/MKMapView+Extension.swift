//
//  MKMapView+Ex.swift
//  HealthCareSystem
//
//  Created by Marwan Osama on 21/06/2021.
//  Copyright © 2021 ALATRAF. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {
    
    func removeAnnotation() {
        annotations.forEach { (anno) in
            if let annotation = anno as? MKPointAnnotation {
                removeAnnotation(annotation)
            }
        }
    }
    
    
    func addAndCenterAnnotation(coordinate: CLLocationCoordinate2D) {
        let anno = MKPointAnnotation()
        anno.coordinate = coordinate
        addAnnotation(anno)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.0035, longitudeDelta: 0.0035)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        setRegion(region, animated: true)
    }
    
    
    
    
}
