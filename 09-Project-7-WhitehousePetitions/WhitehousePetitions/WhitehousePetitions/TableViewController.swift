//
//  TableViewController.swift
//  WhitehousePetitions
//
//  Created by Matt X on 11/18/22.
//

import UIKit

class TableViewController: UITableViewController {
    var petitions: [Petition] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var urlString: String {
            if navigationController?.tabBarItem.tag == 0 {
                return "https://www.hackingwithswift.com/samples/petitions-1.json"
            } else {
                // Live White House API is not working as of 11/18/22...
                return "https://www.hackingwithswift.com/samples/petitions-2.json"
            }
        }
        
        if let url = URL(string: urlString) {
            // Synchronous URL loading realistically should not occur on main thread...
            // It will be fine for this project, though.
            if let data = try? Data(contentsOf: url) {
                parseJSON(data)
                return
            }
        }
        
        showError()
    }
    
    func parseJSON(_ data: Data) {
        if let decodedPetitions = try? JSONDecoder().decode(Petitions.self, from: data) {
            petitions = decodedPetitions.results
            
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        
        cell.textLabel?.text = petition.title
        
        cell.detailTextLabel?.text = petition.body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        detailVC.detailItem = petitions[indexPath.row]
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func showError() {
        let ac = UIAlertController(
            title: "Loading error",
            message: "There was a problem loading the feed. Please check your connection and try again.",
            preferredStyle: .alert
        )
        
        ac.addAction(
            UIAlertAction(title: "OK", style: .default)
        )
        
        present(ac, animated: true)
    }
}
