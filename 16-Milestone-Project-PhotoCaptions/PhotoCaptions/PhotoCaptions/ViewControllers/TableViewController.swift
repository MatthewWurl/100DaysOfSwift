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
        cell.imageView?.image = UIImage(contentsOfFile: photoEntry.imagePath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailVC") {
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
        
        let photoEntry = PhotoEntry(caption: "Some caption...", image: imageName)
        photoEntries.append(photoEntry)
        tableView.reloadData()
        
        dismiss(animated: true)
    }
}

extension Bundle {
    var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
}
