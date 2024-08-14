//
//  API.swift
//  Notes
//
//  Created by Michael Slattery on 7/15/24.
//

import Foundation
import ComposableArchitecture

struct API {
    
    enum Endpoints: String {
        case notes = "http://localhost:8080/notes"
        case login = "http://localhost:8080/login"
    }
    
    var request: @Sendable (URLRequest) async throws -> (Data, URLResponse)
}

extension API: DependencyKey {
    static var liveValue = Self(
        request: { urlRequest in try await URLSession.shared.data(for: urlRequest)}
    )
    
    static let previewValue = Self.mock()
    
    struct NoDataError: Error {}
    
    static func mock(initalData: Data? = nil, response: URLResponse? = nil) -> Self {
        return Self(
            request: { _ in
                guard let data = initalData else {
                    throw NoDataError()
                }
                return (data, response ?? URLResponse())
            }
        )
    }
}

extension DependencyValues {
    var api: API {
        get { self[API.self] }
        set { self[API.self] = newValue }
    }
}
