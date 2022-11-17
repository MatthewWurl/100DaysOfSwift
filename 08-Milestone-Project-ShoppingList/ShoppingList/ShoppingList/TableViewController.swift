//
//  TableViewController.swift
//  ShoppingList
//
//  Created by Matt X on 11/16/22.
//

import UIKit

class TableViewController: UITableViewController {
    var shoppingList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shopping List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped)
        )
        
        let shareButton = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(shareButtonTapped)
        )
        
        let clearButton = UIBarButtonItem(
            title: "Clear",
            style: .plain,
            target: self,
            action: #selector(clearButtonTapped)
        )
        
        navigationItem.leftBarButtonItem = clearButton
        navigationItem.rightBarButtonItems = [addButton, shareButton]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListItem", for: indexPath)
        
        cell.textLabel?.text = shoppingList[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
    
    @objc func addButtonTapped() {
        print("Add button tapped.")
        
        let ac = UIAlertController(
            title: "Add item to list",
            message: nil,
            preferredStyle: .alert
        )
        
        ac.addTextField()
        
        ac.addAction(
            UIAlertAction(title: "Add", style: .default) { [weak self] _ in
                if let item = ac.textFields?.first?.text?.trimmingCharacters(in: .whitespaces) {
                    guard let self = self else { return }
                    guard item.count > 0 else {
                        self.showErrorAlert(
                            title: "No item entered",
                            message: "You have to type something!"
                        )
                        return
                    }
                    
                    let listCount = self.shoppingList.count
                    
                    self.shoppingList.insert(item, at: listCount)
                    
                    let indexPath = IndexPath(row: listCount, section: 0)
                    self.tableView.insertRows(at: [indexPath], with: .automatic)
                }
            }
        )
        
        ac.addAction(
            UIAlertAction(title: "Cancel", style: .cancel)
        )
        
        present(ac, animated: true)
    }
    
    @objc func shareButtonTapped() {
        let listString = shoppingList.joined(separator: ", ")
        let activityVC = UIActivityViewController(
            activityItems: [listString],
            applicationActivities: nil
        )
        
        present(activityVC, animated: true)
    }
    
    @objc func clearButtonTapped() {
        shoppingList.removeAll(keepingCapacity: true)
        
        tableView.reloadData()
    }
    
    func showErrorAlert(title: String, message: String) {
        let errorAC = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        errorAC.addAction(
            UIAlertAction(title: "OK", style: .cancel)
        )
        
        present(errorAC, animated: true)
    }
}
