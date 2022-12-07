//
//  Person.swift
//  NamesToFaces
//
//  Created by Matt X on 11/28/22.
//

import UIKit

class Person: NSObject, NSCoding {
    static let defaultName = "Unknown"
    
    var name: String
    let image: String
    
    init(name: String = defaultName, image: String) {
        self.name = name
        self.image = image
    }
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as? String ?? ""
        image = coder.decodeObject(forKey: "image") as? String ?? ""
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(image, forKey: "image")
    }
}
