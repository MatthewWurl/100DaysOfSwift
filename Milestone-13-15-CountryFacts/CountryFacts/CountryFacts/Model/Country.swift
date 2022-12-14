//
//  Country.swift
//  CountryFacts
//
//  Created by Matt X on 12/14/22.
//

import Foundation

struct Country: Codable, Identifiable {
    let capital: [String]
    let code: String
    let name: CountryName
    let population: Int
    let region: String
    
    var id: String { name.common }
    
    var flagImageName: String {
        code.lowercased() // "mx", "pl", "us"
    }
    
    private enum CodingKeys: String, CodingKey {
        case capital
        case code = "cca2"
        case name
        case population
        case region
    }
    
    struct CountryName: Codable {
        let common: String
        let official: String
    }
    
    // 40 different countries...
    static let countryCodes = [
        "ad", "ar", "be", "bf", "br", "bw", "ca", "ch", "ci", "cm",
        "co", "cz", "de", "dk", "ec", "fi", "fr", "gb", "gn", "in",
        "it", "jp", "kr", "lb", "lt", "lu", "ma", "md", "mx", "nf",
        "nz", "pl", "rw", "se", "sj", "sn", "td", "us", "uy", "ve"
    ]
}
