//
//  URLRequest+Extension.swift
//  Notes
//
//  Created by Michael Slattery on 10/13/24.
//

import Foundation

extension URLRequest {
    mutating func setCommonHeaders() {
        addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    }
}
