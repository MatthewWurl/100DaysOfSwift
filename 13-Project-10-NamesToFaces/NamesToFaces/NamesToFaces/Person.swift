//
//  Person.swift
//  NamesToFaces
//
//  Created by Matt X on 11/28/22.
//

import UIKit

class Person: NSObject {
    var name: String
    let image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
