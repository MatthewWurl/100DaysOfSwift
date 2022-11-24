//
//  TableViewController.swift
//  WhitehousePetitions
//
//  Created by Matt X on 11/18/22.
//

import UIKit

class TableViewController: UITableViewController {
    var petitions: [Petition] = []
    var filteredPetitions: [Petition] = []
    
    var urlString: String {
        if navigationController?.tabBarItem.tag == 0 {
            return "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            // Live White House API is not working as of 11/18/22...
            return "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let creditsButton = UIBarButtonItem(
            title: "Credits",
            style: .plain,
            target: self,
            action: #selector(creditsButtonTapped)
        )
        
        let filterButton = UIBarButtonItem(
            title: "Filter",
            style: .plain,
            target: self,
            action: #selector(filterButtonTapped)
        )
        
        navigationItem.leftBarButtonItem = filterButton
        navigationItem.rightBarButtonItem = creditsButton
        
        performSelector(inBackground: #selector(fetchJSON), with: nil)
    }
    
    @objc func fetchJSON() {
        if let url = URL(string: urlString) {
            // Synchronous URL loading realistically should not occur on main thread...
            // It will be fine for this project, though.
            if let data = try? Data(contentsOf: url) {
                parseJSON(data)
                return
            }
        }
        
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    func parseJSON(_ data: Data) {
        if let decodedPetitions = try? JSONDecoder().decode(Petitions.self, from: data) {
            petitions = decodedPetitions.results
            filteredPetitions = petitions
            
            tableView.performSelector(
                onMainThread: #selector(UITableView.reloadData),
                with: nil,
                waitUntilDone: false
            )
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        
        cell.textLabel?.text = petition.title
        
        cell.detailTextLabel?.text = petition.body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        detailVC.detailItem = filteredPetitions[indexPath.row]
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @objc func showError() {
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
    
    @objc func filterButtonTapped() {
        let ac = UIAlertController(
            title: "Filter",
            message: "Please enter a string to filter by.",
            preferredStyle: .alert
        )
        
        ac.addTextField()
        
        ac.addAction(
            UIAlertAction(title: "Cancel", style: .cancel)
        )
        
        ac.addAction(
            UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                if let filterString = ac.textFields?.first?.text?.trimmingCharacters(in: .whitespaces) {
                    guard let self = self else { return }
                    
                    self.filteredPetitions = self.petitions.filter { petition in
                        petition.title.localizedCaseInsensitiveContains(filterString)
                    }
                    
                    self.tableView.reloadData()
                }
            }
        )
        
        present(ac, animated: true)
    }
    
    @objc func creditsButtonTapped() {
        let ac = UIAlertController(
            title: "Credits",
            message: "This data comes from the We The People API of the Whitehouse.",
            preferredStyle: .alert
        )
        
        ac.addAction(
            UIAlertAction(title: "OK", style: .default)
        )
        
        present(ac, animated: true)
    }
}
