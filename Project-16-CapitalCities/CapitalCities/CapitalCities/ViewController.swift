//
//  ViewController.swift
//  CapitalCities
//
//  Created by Matt X on 12/14/22.
//

import MapKit
import UIKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let londonCoordinate = CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275)
        let london = Capital(
            title: "London",
            coordinate: londonCoordinate,
            info: "Home to the 2012 Summer Olympics."
        )
        
        let osloCoordinate = CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75)
        let oslo = Capital(
            title: "Oslo",
            coordinate: osloCoordinate,
            info: "Founded over a thousand years ago."
        )
        
        let parisCoordinate = CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508)
        let paris = Capital(
            title: "Paris",
            coordinate: parisCoordinate,
            info: "Often called the City of Light."
        )
        
        let romeCoordinate = CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5)
        let rome = Capital(
            title: "Rome",
            coordinate: romeCoordinate,
            info: "Has a whole country inside it."
        )
        
        let washingtonCoordinate = CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667)
        let washington = Capital(
            title: "Washington, D.C.",
            coordinate: washingtonCoordinate,
            info: "Named after George himself."
        )
        
        let capitals = [london, oslo, paris, rome, washington]
        mapView.addAnnotations(capitals)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let button = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = button
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        
        let ac = UIAlertController(
            title: capital.title,
            message: capital.info,
            preferredStyle: .alert
        )
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(ac, animated: true)
    }
}
