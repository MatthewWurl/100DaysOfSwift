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
        
        // Load photo entries from UserDefaults if possible...
        DispatchQueue.global().async { [weak self] in
            if let photoEntriesData = UserDefaults.standard.data(forKey: "photoEntries") {
                do {
                    self?.photoEntries = try JSONDecoder().decode([PhotoEntry].self, from: photoEntriesData)
                } catch {
                    print("Failed to load photo entries.")
                }
            }
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoEntries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let photoEntry = photoEntries[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoEntryCell", for: indexPath)
        
        if let cell = cell as? PhotoEntryCell {
            cell.photoLabel.text = photoEntry.caption
            
            cell.photoImageView.image = UIImage(contentsOfFile: photoEntry.imagePath)
            cell.photoImageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
            cell.photoImageView.layer.borderWidth = 1
            cell.photoImageView.layer.cornerRadius = 8
        }
        
        return cell
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
        
        DispatchQueue.global().async { [weak self] in
            let imageName = UUID().uuidString
            let imagePath = Bundle.main.documentsDirectory.appendingPathExtension(imageName)
            
            if let jpegData = image.jpegData(compressionQuality: 0.8) {
                try? jpegData.write(to: imagePath)
            }
            
            DispatchQueue.main.async {
                self?.dismiss(animated: true)
                
                self?.showCaptionAlert(forImage: imageName)
            }
        }
    }
    
    func showCaptionAlert(forImage image: String) {
        let captionAlert = UIAlertController(
            title: nil,
            message: "What would you like the caption to be?",
            preferredStyle: .alert
        )
        
        captionAlert.addTextField()
        captionAlert.addAction(
            UIAlertAction(title: "OK", style: .default) { [weak self, weak captionAlert] _ in
                guard let caption = captionAlert?.textFields?.first?.text else { return }
                
                let photoEntry = PhotoEntry(caption: caption, image: image)
                self?.photoEntries.append(photoEntry)
                
                self?.savePhotoEntries()
            }
        )
        
        present(captionAlert, animated: true)
    }
    
    func savePhotoEntries() {
        DispatchQueue.global().async { [weak self] in
            guard let photoEntries = self?.photoEntries else { return }
            
            if let savedPhotoEntries = try? JSONEncoder().encode(photoEntries) {
                UserDefaults.standard.set(savedPhotoEntries, forKey: "photoEntries")
            } else {
                print("Failed to save photo entries.")
            }
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}
