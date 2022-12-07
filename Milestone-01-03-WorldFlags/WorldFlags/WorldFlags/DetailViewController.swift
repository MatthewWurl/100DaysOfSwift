//
//  DetailViewController.swift
//  WorldFlags
//
//  Created by Matt X on 11/8/22.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    var flagName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = flagName
        navigationItem.largeTitleDisplayMode = .never
        
        if let flagName = flagName {
            imageView.image = UIImage(named: flagName)
        }
        
        let shareButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(shareTapped)
        )
        
        navigationItem.rightBarButtonItem = shareButtonItem
    }
    
    @objc func shareTapped() {
        guard let flagImageData = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("Could not grab image data...")
            return
        }
        
        guard let flagName = flagName else {
            print("Could not get flag name...")
            return
        }
        
        let activityVC = UIActivityViewController(
            activityItems: [flagName, flagImageData],
            applicationActivities: []
        )
        
        activityVC.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(activityVC, animated: true)
    }
}
