//
//  AddViewController.swift
//  PhotoCaptions
//
//  Created by Matt X on 12/5/22.
//

import UIKit

class AddViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add a new captioned photo"
        
        let closeButton = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: nil
        )
        navigationItem.rightBarButtonItem = closeButton
    }
}
