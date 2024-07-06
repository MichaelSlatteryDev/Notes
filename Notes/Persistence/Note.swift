//
//  Note.swift
//  Notes
//
//  Created by Michael Slattery on 6/22/24.
//

import Foundation

struct Note: Identifiable, Equatable, Codable {
    let id: UUID
    var title: String
    var body: String

    init(id: UUID, title: String, body: String) {
        self.id = id
        self.title = title
        self.body = body
    }

    static func == (lhs: Note, rhs: Note) -> Bool {
        lhs.id == rhs.id
    }
}

//@Model
//public class Note: Identifiable, Equatable {
//    let id: UUID
//    var title: String
//    var body: String
//    
//    init(id: UUID, title: String, body: String) {
//        self.id = id
//        self.title = title
//        self.body = body
//    }
//    
//    static func == (lhs: Note, rhs: Note) -> Bool {
//        lhs.id == rhs.id &&
//        lhs.title == rhs.title &&
//        lhs.body == rhs.body
//    }
//}
