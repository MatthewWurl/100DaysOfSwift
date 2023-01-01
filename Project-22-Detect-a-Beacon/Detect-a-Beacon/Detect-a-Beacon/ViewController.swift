//
//  ViewController.swift
//  Detect-a-Beacon
//
//  Created by Matt X on 12/30/22.
//

import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var distanceReadingLabel: UILabel!
    @IBOutlet weak var beaconLabel: UILabel!
    
    var locationManager: CLLocationManager?
    var beaconDetected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(uuid: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            switch distance {
            case .far:
                self.view.backgroundColor = .blue
                self.distanceReadingLabel.text = "FAR"
            case .near:
                self.view.backgroundColor = .orange
                self.distanceReadingLabel.text = "NEAR"
            case .immediate:
                self.view.backgroundColor = .red
                self.distanceReadingLabel.text = "RIGHT HERE"
            default:
                self.view.backgroundColor = .gray
                self.distanceReadingLabel.text = "UNKNOWN"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
            
            switch beaconDetected {
            case true:
                break
            case false:
                showFirstDetectionAlert()
                beaconDetected = true
            }
        } else {
            update(distance: .unknown)
        }
    }
    
    func showFirstDetectionAlert() {
        let detectionAlert = UIAlertController(
            title: "Beacon Detected",
            message: "A beacon has been detected nearby.",
            preferredStyle: .alert
        )
        
        detectionAlert.addAction(
            UIAlertAction(title: "OK", style: .default)
        )
        
        present(detectionAlert, animated: true)
    }
}
