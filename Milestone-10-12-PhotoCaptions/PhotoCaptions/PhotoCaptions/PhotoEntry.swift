//
//  PhotoEntry.swift
//  PhotoCaptions
//
//  Created by Matt X on 12/5/22.
//

import Foundation

struct PhotoEntry: Codable {
    let caption: String
    let image: String
    
    var imagePath: String {
        return Bundle.main.documentsDirectory.appendingPathExtension(image).path
    }
}
