//
//  TableViewController.swift
//  PhotoCaptions
//
//  Created by Matt X on 12/5/22.
//

import UIKit

class TableViewController: UITableViewController,
                           UIImagePickerControllerDelegate,
                           UINavigationControllerDelegate {
    var photoEntries: [PhotoEntry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Photo Captions"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonPressed)
        )
        navigationItem.rightBarButtonItem = addButton
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoEntries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let photoEntry = photoEntries[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCaptionCell", for: indexPath)
        cell.textLabel?.text = photoEntry.caption
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photoEntry = photoEntries[indexPath.row]
        
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailViewController {
            detailVC.photoEntry = photoEntry
            
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    @objc func addButtonPressed() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = Bundle.main.documentsDirectory.appendingPathExtension(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        dismiss(animated: true)
        
        showCaptionAlert(forImage: imageName)
    }
    
    func showCaptionAlert(forImage image: String) {
        let captionAlert = UIAlertController(
            title: "Please type a caption.",
            message: nil,
            preferredStyle: .alert
        )
        
        captionAlert.addTextField()
        captionAlert.addAction(
            UIAlertAction(title: "OK", style: .default) { [weak self, weak captionAlert] _ in
                guard let caption = captionAlert?.textFields?.first?.text else { return }
                
                let photoEntry = PhotoEntry(caption: caption, image: image)
                self?.photoEntries.append(photoEntry)
                
                self?.tableView.reloadData()
            }
        )
        
        present(captionAlert, animated: true)
    }
}
