//
//  KeychainManager.swift
//  Notes
//
//  Created by Michael Slattery on 10/15/24.
//

import Foundation
import ComposableArchitecture
import Security

struct KeychainManager {
    
    enum KeyChainError: Error {
        case add
        case get
        case update
        case delete
        
        case itemAlreadyExists
    }
    
    private enum ErrorStatus: OSStatus {
        case itemAlreadyExists = -25299
    }
    
    enum DataType {
        case password
        case token
        
        var securityParameter: CFString {
            switch self {
            case .password, .token: return kSecClassGenericPassword
            }
        }
        
        var key: String? {
            guard let username = UserDefaults.standard.string(forKey: "Username") else { return nil }
            
            switch self {
            case .password: return "\(username)_password"
            case .token: return "\(username)_token"
            }
        }
    }
    
    var add: @Sendable (DataType, String) throws -> Void
    var get: @Sendable (DataType) -> String?
    var update: @Sendable (DataType, String) throws -> Void
    var delete: @Sendable (DataType) throws -> Void
}

extension KeychainManager: DependencyKey {
    
    static var liveValue = Self(
        add: { datatype, value in
            
            guard let key = datatype.key, let data = value.data(using: .utf8) else { throw KeyChainError.add }
            
            let addQuery: [String: Any] = [
                kSecClass as String: datatype.securityParameter,
                kSecAttrAccount as String: key,
                kSecValueData as String: data,
            ]
            
            let status = SecItemAdd(addQuery as CFDictionary, nil)
            
            print(SecCopyErrorMessageString(status, nil))
        },
        get: { datatype in
            
            guard let key = datatype.key else { return nil }
            
            let getQuery: [String: Any] = [
                kSecClass as String: datatype.securityParameter,
                kSecAttrAccount as String: key,
                kSecMatchLimit as String: kSecMatchLimitOne,
                kSecReturnAttributes as String: true,
                kSecReturnData as String: true,
            ]

            var item: CFTypeRef?
            SecItemCopyMatching(getQuery as CFDictionary, &item)
            
            // Extract result
            if let existingItem = item as? [String: Any],
               let passwordData = existingItem[kSecValueData as String] as? Data,
               let password = String(data: passwordData, encoding: .utf8) {
                return password
            }
            
            return nil
        },
        update: { datatype, newValue in
            
            guard let key = datatype.key, let data = newValue.data(using: .utf8) else { throw KeyChainError.update }
            
            let updateQuery: [String: Any] = [
                kSecClass as String: datatype.securityParameter,
                kSecAttrAccount as String: key,
            ]
            
            let attributes: [String: Any] = [kSecValueData as String: data]
            let status = SecItemUpdate(updateQuery as CFDictionary, attributes as CFDictionary)
            
            print(SecCopyErrorMessageString(status, nil))
        }, delete: { datatype in
            
            guard let key = datatype.key else { throw KeyChainError.delete }
            
            let deleteQuery: [String: Any] = [
                kSecClass as String: datatype.securityParameter,
                kSecAttrAccount as String: key,
            ]
            
            let status = SecItemDelete(deleteQuery as CFDictionary)
            
            print(SecCopyErrorMessageString(status, nil))
        }
    )
    
    static let previewValue = Self.mock()
    
    static func mock() -> Self {
        return Self(
            add: { username, password in
                
            },
            get: { username in
                return ""
            },
            update: { username, newPassword in
                
            },
            delete: { username in
                
            }
        )
    }
}

extension DependencyValues {
    var keychainManager: KeychainManager {
        get { self[KeychainManager.self] }
        set { self[KeychainManager.self] = newValue }
    }
}
