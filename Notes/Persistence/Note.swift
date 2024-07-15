//
//  Note.swift
//  Notes
//
//  Created by Michael Slattery on 6/22/24.
//

import Foundation

struct Note: Identifiable, Equatable, Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case body = "description"
    }
    
    let id: String
    var title: String
    var body: String

    init(id: String, title: String, body: String) {
        self.id = id
        self.title = title
        self.body = body
    }

//    static func == (lhs: Note, rhs: Note) -> Bool {
//        lhs.id == rhs.id
//    }
}
