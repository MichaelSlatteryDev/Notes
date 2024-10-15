//
//  API.swift
//  Notes
//
//  Created by Michael Slattery on 7/15/24.
//

import Foundation
import ComposableArchitecture

struct API {
    
    enum Endpoints {
        case notes
        case login(String)
        case register
        case verify
        
        private static var hostUrl = "http://localhost:8080"
        
        var value: String {
            switch self {
            case .notes:
                "\(Self.hostUrl)/notes"
            case .login(let username):
                "\(Self.hostUrl)/login/\(username)"
            case .register:
                "\(Self.hostUrl)/register"
            case .verify:
                "\(Self.hostUrl)/verify"
            }
        }
    }
    
    var request: @Sendable (URLRequest) async throws -> (Data, URLResponse)
    var authorizedRequest: @Sendable (URLRequest, String, String) async throws -> (Data, URLResponse)
}

// MARK: DependencyKey
extension API: DependencyKey {
    static var liveValue = Self(
        request: { urlRequest in
            var mutatedRequest = urlRequest
            mutatedRequest.setCommonHeaders()
            return try await URLSession.shared.data(for: mutatedRequest)
        },
        authorizedRequest: { urlRequest, username, password in
            
            var mutatedRequest = urlRequest
            let token: String? = await getToken(for: username, password: password)
            
            // Step 4: Add the token to the request header if it exists
            if let validToken = token {
                mutatedRequest.setCommonHeaders()
                mutatedRequest.setValue("Bearer \(validToken)", forHTTPHeaderField: "Authorization")
            }
            
            return try await URLSession.shared.data(for: mutatedRequest)
        }
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
            },
            authorizedRequest: { _, _, _ in
               guard let data = initalData else {
                   throw NoDataError()
               }
               return (data, response ?? URLResponse())
            }
        )
    }
}

// MARK: Token
extension API {
    private static func getToken(for username: String, password: String) async -> String? {
        // Step 1: Check if the token exists in UserDefaults
        if let storedToken = UserDefaults.standard.string(forKey: "jwtToken"),
           !isTokenExpired(token: storedToken) {
            return storedToken
        } else {
            // Step 2: Token doesn't exist or expired, request a new token from verify
            var authRequest = URLRequest(url: URL(string: API.Endpoints.verify.value)!)
            let jsonData = try? JSONEncoder().encode(User(name: username, password: password, notes: []))
            authRequest.httpBody = jsonData
            authRequest.httpMethod = "POST"
            authRequest.setCommonHeaders()
            
            do {
                let (data, response) = try await URLSession.shared.data(for: authRequest)
                if let newToken = String(data: data, encoding: .utf8), let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        // Step 3: Store the new token in UserDefaults
                        UserDefaults.standard.set(newToken, forKey: "jwtToken")
                        
                        return newToken
                    } else {
                        UserDefaults.standard.removeObject(forKey: "jwtToken")
                    }
                }
            } catch {
                print("Failed to fetch token: \(error)")
            }
        }
        
        return nil
    }
    
    // Helper function to check if the JWT token is expired
    private static func isTokenExpired(token: String) -> Bool {
        let components = token.split(separator: ".")
        if components.count == 3 {
            let payloadData = components[1] // The payload is in base64 format
            let payload = decodeBase64String(String(payloadData))
            if let exp = payload["exp"] as? Double {
                let expirationDate = Date(timeIntervalSince1970: exp)
                return expirationDate <= Date()
            }
        }
        return true
    }

    // Helper function to decode the base64-encoded JWT payload
    private static func decodeBase64String(_ str: String) -> [String: Any] {
        if let data = Data(base64Encoded: str),
           let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            return json
        }
        return [:]
    }
}

extension DependencyValues {
    var api: API {
        get { self[API.self] }
        set { self[API.self] = newValue }
    }
}
