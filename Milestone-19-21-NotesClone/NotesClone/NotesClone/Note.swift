//
//  Note.swift
//  NotesClone
//
//  Created by Matt X on 12/28/22.
//

import Foundation

struct Note: Codable, Identifiable {
    var id: UUID = UUID()
    var title: String = "New Note"
    var content: String = ""
    var creationDate: Date = Date.now
    
    var hasContent: Bool {
        return !content.isEmpty
    }
}
