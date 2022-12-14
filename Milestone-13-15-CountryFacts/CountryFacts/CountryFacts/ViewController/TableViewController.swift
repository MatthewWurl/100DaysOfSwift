//
//  TableViewController.swift
//  CountryFacts
//
//  Created by Matt X on 12/14/22.
//

import UIKit

class TableViewController: UITableViewController {
    private var countries: [Country] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Country Facts"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchCountries()
        }
    }
    
    func fetchCountries() {
        let joinedCodes = Country.countryCodes.joined(separator: ",")
        
        guard let url = URL(string: "https://restcountries.com/v3.1/alpha?codes=\(joinedCodes)") else {
            fatalError("Invalid URL provided for countries.")
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let data = data {
                do {
                    self.countries = try JSONDecoder().decode([Country].self, from: data)
                    
                    DispatchQueue.main.async {
                        self.countries.sort { $0.name.common < $1.name.common }
                        
                        self.tableView.reloadData()
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        task.resume()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
        let country = countries[indexPath.row]
        
        if let cell = cell as? CountryCell {
            cell.smallFlagImageView.image = UIImage(named: country.flagImageName)
            cell.smallFlagImageView.layer.borderColor = UIColor.lightGray.cgColor
            cell.smallFlagImageView.layer.borderWidth = 2
            cell.smallFlagImageView.layer.cornerRadius = 8
            
            cell.nameLabel.text = country.name.common
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = countries[indexPath.row]
        
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            detailVC.country = country
            
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
