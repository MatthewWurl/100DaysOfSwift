//
//  CollectionViewController.swift
//  NamesToFaces
//
//  Created by Matt X on 11/27/22.
//

import UIKit

class CollectionViewController: UICollectionViewController,
                                UIImagePickerControllerDelegate,
                                UINavigationControllerDelegate {
    var people: [Person] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewPerson)
        )
        navigationItem.leftBarButtonItem = addButton
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell.")
        }
        
        let person = people[indexPath.item]
        cell.nameLabel.text = person.name
        
        let path = Bundle.documentsDirectory.appending(path: person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        cell.imageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        switch person.name == Person.defaultName {
        case true:
            showRenameAlert(for: person)
        case false:
            showRenameOrDeleteAlert(for: person)
        }
    }
    
    func showRenameAlert(for person: Person) {
        let renameAlert = UIAlertController(
            title: "Selected \"\(person.name)\"",
            message: "What would you like this person's new name to be?",
            preferredStyle: .alert
        )
        renameAlert.addTextField()
        
        renameAlert.addAction(
            UIAlertAction(title: "OK", style: .default) { [weak self, weak renameAlert] _ in
                guard let newName = renameAlert?.textFields?.first?.text else { return }
                person.name = newName
                
                self?.collectionView.reloadData()
            }
        )
        
        renameAlert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel)
        )
        
        present(renameAlert, animated: true)
    }
    
    func showRenameOrDeleteAlert(for person: Person) {
        let deleteAlert = UIAlertController(
            title: "Selected \"\(person.name)\"",
            message: "Would you like to rename or delete this person?",
            preferredStyle: .alert
        )
        
        // Rename...
        deleteAlert.addAction(
            UIAlertAction(title: "Rename", style: .default) { [weak self] _ in
                self?.showRenameAlert(for: person)
            }
        )
        
        // Delete...
        deleteAlert.addAction(
            UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                guard let personIndex = self?.people.firstIndex(of: person) else { return }
                
                self?.people.remove(at: personIndex)
                self?.collectionView.reloadData()
            }
        )
        
        // Cancel...
        deleteAlert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel)
        )
        
        present(deleteAlert, animated: true)
    }
    
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = Bundle.documentsDirectory.appending(path: imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(image: imageName)
        people.append(person)
        collectionView?.reloadData()
        
        dismiss(animated: true)
    }
}
