//
//  User.swift
//  Notes
//
//  Created by Michael Slattery on 8/14/24.
//

import Foundation

struct User: Codable, Equatable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "username"
        case password
        case notes
    }
    
    var id: String?
    var name: String
    var password: String
    var notes: [Note]
}
