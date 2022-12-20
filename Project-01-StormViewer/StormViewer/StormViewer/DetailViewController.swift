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

        assert(selectedImage != nil, "selectedImage does not have a value.")
        
        imageView.image = UIImage(named: selectedImage!)
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
