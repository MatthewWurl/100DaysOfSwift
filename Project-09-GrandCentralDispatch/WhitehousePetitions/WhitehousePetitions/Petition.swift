//
//  Petition.swift
//  WhitehousePetitions
//
//  Created by Matt X on 11/18/22.
//

import Foundation

struct Petition: Codable {
    let title: String
    let body: String
    let signatureCount: Int
}
