//
//  DetailViewController.swift
//  CountryFacts
//
//  Created by Matt X on 12/14/22.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var largeFlagImageView: UIImageView!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    
    var country: Country!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = country.name.common
        navigationItem.largeTitleDisplayMode = .never
        
        setDetailsForCountry()
    }
    
    func setDetailsForCountry() {
        largeFlagImageView.image = UIImage(named: country.flagImageName)
        
        capitalLabel.text = "Capital: \(country.capital.joined(separator: ","))"
        countryCodeLabel.text = "Country code: \(country.code)"
        populationLabel.text = "Population: \(country.population.formatted(.number))"
        regionLabel.text = "Region: \(country.region)"
    }
}
