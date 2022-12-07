//
//  ViewController.swift
//  Instafilter
//
//  Created by Matt X on 12/7/22.
//

import UIKit

class ViewController: UIViewController,
                      UIImagePickerControllerDelegate,
                      UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var intensitySlider: UISlider!
    
    var currentImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Instafilter"
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(importPicture)
        )
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        currentImage = image
    }

    @IBAction func intensityChanged(_ sender: UISlider) {
        
    }
    
    @IBAction func changeFilterTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        
    }
}

