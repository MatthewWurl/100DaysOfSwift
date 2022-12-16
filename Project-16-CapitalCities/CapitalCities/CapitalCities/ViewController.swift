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
        
        title = "Capital Cities"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let londonCoordinate = CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275)
        let london = Capital(
            title: "London",
            coordinate: londonCoordinate,
            wikiUrl: URL(string: "https://en.wikipedia.org/wiki/London")!
        )
        
        let osloCoordinate = CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75)
        let oslo = Capital(
            title: "Oslo",
            coordinate: osloCoordinate,
            wikiUrl: URL(string: "https://en.wikipedia.org/wiki/Oslo")!
        )
        
        let parisCoordinate = CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508)
        let paris = Capital(
            title: "Paris",
            coordinate: parisCoordinate,
            wikiUrl: URL(string: "https://en.wikipedia.org/wiki/Paris")!
        )
        
        let romeCoordinate = CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5)
        let rome = Capital(
            title: "Rome",
            coordinate: romeCoordinate,
            wikiUrl: URL(string: "https://en.wikipedia.org/wiki/Rome")!
        )
        
        let washingtonCoordinate = CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667)
        let washington = Capital(
            title: "Washington, D.C.",
            coordinate: washingtonCoordinate,
            wikiUrl: URL(string: "https://en.wikipedia.org/wiki/Washington,_D.C.")!
        )
        
        let mapTypeButton = UIBarButtonItem(
            title: "Map Type",
            image: nil,
            target: self,
            action: #selector(mapTypeButtonTapped)
        )
        navigationItem.rightBarButtonItem = mapTypeButton
        
        let capitals = [london, oslo, paris, rome, washington]
        mapView.addAnnotations(capitals)
    }
    
    @objc func mapTypeButtonTapped() {
        let ac = UIAlertController(
            title: "Set Map Type",
            message: nil,
            preferredStyle: .alert
        )
        ac.addAction(
            UIAlertAction(title: "Hybrid", style: .default) { [weak self] _ in
                self?.mapView.mapType = .hybrid
            }
        )
        ac.addAction(
            UIAlertAction(title: "Hybrid Flyover", style: .default) { [weak self] _ in
                self?.mapView.mapType = .hybridFlyover
            }
        )
        ac.addAction(
            UIAlertAction(title: "Satellite", style: .default) { [weak self] _ in
                self?.mapView.mapType = .satellite
            }
        )
        ac.addAction(
            UIAlertAction(title: "Standard", style: .default) { [weak self] _ in
                self?.mapView.mapType = .standard
            }
        )
        ac.addAction(
            UIAlertAction(title: "Cancel", style: .cancel)
        )
        
        present(ac, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let button = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = button
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.markerTintColor = .blue
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        
        // Show web view...
        if let wikiVC = storyboard?.instantiateViewController(withIdentifier: "WikiVC") as? WikiViewController {
            wikiVC.capital = capital
            
            present(wikiVC, animated: true)
        }
    }
}
