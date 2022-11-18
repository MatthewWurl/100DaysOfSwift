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
        
        let urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        
        if let url = URL(string: urlString) {
            // Synchronous URL loading realistically should not occur on main thread...
            // It will be fine for this project, though.
            if let data = try? Data(contentsOf: url) {
                parseJSON(data)
            }
        }
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
        
        print("Title: \(petition.title)")
        
        cell.detailTextLabel?.text = petition.body
        
        return cell
    }
}
