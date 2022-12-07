//
//  Bundle-Extension.swift
//  PhotoCaptions
//
//  Created by Matt X on 12/7/22.
//

import Foundation

extension Bundle {
    var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
}
