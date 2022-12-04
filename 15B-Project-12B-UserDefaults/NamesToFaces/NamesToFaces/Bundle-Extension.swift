//
//  Bundle-Extension.swift
//  NamesToFaces
//
//  Created by Matt X on 11/28/22.
//

import Foundation

extension Bundle {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
}
