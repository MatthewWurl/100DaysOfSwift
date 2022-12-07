//
//  DetailViewController.swift
//  StormViewer
//
//  Created by Matt X on 11/2/22.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    var selectedImage: String?
    var titleString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = titleString
        navigationItem.largeTitleDisplayMode = .never

        if let selectedImage = selectedImage {
            imageView.image = UIImage(named: selectedImage)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.hidesBarsOnTap = false
    }
}
