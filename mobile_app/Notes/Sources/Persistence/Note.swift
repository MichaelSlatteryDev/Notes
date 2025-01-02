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

    let id: String?
    var title: String
    var body: String
    let userId: String

    init(id: String? = nil, title: String, body: String, userId: String) {
        self.id = id
        self.title = title
        self.body = body
        self.userId = userId
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        body = try container.decode(String.self, forKey: .body)
        let userId = try container.decode(Int.self, forKey: .userId)
        self.userId = String(userId)
    }
}
