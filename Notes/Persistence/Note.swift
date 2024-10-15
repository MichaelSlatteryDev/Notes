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
        case userId
    }
    
    let id: String
    var title: String
    var body: String
    let userId: Int?

    init(id: String, title: String, body: String, userId: Int? = nil) {
        self.id = id
        self.title = title
        self.body = body
        self.userId = userId
    }
}
