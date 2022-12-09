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
    @IBOutlet weak var changeFilterButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var intensitySlider: UISlider!
    @IBOutlet weak var radiusSlider: UISlider!
    
    var context: CIContext!
    var currentFilter: CIFilter! {
        didSet {
            changeFilterButton.setTitle(
                "Current Filter: \(currentFilter.name)",
                for: .normal
            )
        }
    }
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
        
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
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
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
    
    @IBAction func intensityChanged(_ sender: UISlider) {
        applyProcessing()
    }
    
    @IBAction func radiusChanged(_ sender: UISlider) {
        applyProcessing()
    }
    
    @IBAction func changeFilterTapped(_ sender: UIButton) {
        let filters = [
            "CIBumpDistortion", "CIGaussianBlur", "CIPixellate", "CISepiaTone",
            "CITwirlDistortion", "CIUnsharpMask", "CIVignette"
        ]
        
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        
        for filter in filters {
            ac.addAction(
                UIAlertAction(title: filter, style: .default, handler: setFilter)
            )
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        ac.popoverPresentationController?.sourceView = sender
        ac.popoverPresentationController?.sourceRect = sender.bounds
        
        present(ac, animated: true)
    }
    
    func setFilter(_ action: UIAlertAction) {
        guard currentImage != nil else { return }
        guard let actionTitle = action.title else { return }
        
        currentFilter = CIFilter(name: actionTitle)
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        guard let image = imageView.image else {
            // No image in image view...
            let ac = UIAlertController(
                title: "No image found",
                message: "There is nothing that can be saved!",
                preferredStyle: .alert
            )
            ac.addAction(
                UIAlertAction(title: "OK", style: .default)
            )
            
            present(ac, animated: true)
            
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(
            image,
            self,
            #selector(image(_:didFinishSavingWithError:contextInfo:)), nil
        )
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        let intensity = intensitySlider.value
        let radius = radiusSlider.value
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(intensity, forKey: kCIInputIntensityKey)
        }
        
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(radius * 800, forKey: kCIInputRadiusKey)
        }
        
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(intensity * 2, forKey: kCIInputScaleKey)
        }
        
        if inputKeys.contains(kCIInputCenterKey) {
            currentFilter.setValue(
                CIVector(
                    x: currentImage.size.width / 2,
                    y: currentImage.size.height / 2
                ),
                forKey: kCIInputCenterKey
            )
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        let cgImage = context.createCGImage(
            outputImage,
            from: outputImage.extent
        )
        
        if let cgImage = cgImage {
            let processedImage = UIImage(cgImage: cgImage)
            imageView.image = processedImage
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        guard error == nil else {
            let ac = UIAlertController(
                title: "Save error",
                message: error?.localizedDescription,
                preferredStyle: .alert
            )
            ac.addAction(
                UIAlertAction(title: "OK", style: .default)
            )
            
            present(ac, animated: true)
            
            return
        }
        
        let ac = UIAlertController(
            title: "Saved!",
            message: "Your altered image has been saved to your photos.",
            preferredStyle: .alert
        )
        ac.addAction(
            UIAlertAction(title: "OK", style: .default)
        )
        
        present(ac, animated: true)
    }
}
