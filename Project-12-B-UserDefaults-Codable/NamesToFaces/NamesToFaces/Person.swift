//
//  Person.swift
//  NamesToFaces
//
//  Created by Matt X on 11/28/22.
//

import UIKit

class Person: NSObject, Codable {
    static let defaultName = "Unknown"
    
    var name: String
    let image: String
    
    init(name: String = defaultName, image: String) {
        self.name = name
        self.image = image
    }
}
