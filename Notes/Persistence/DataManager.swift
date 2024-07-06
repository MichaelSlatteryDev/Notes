//
//  DataManager.swift
//  Notes
//
//  Created by Michael Slattery on 6/23/24.
//

import Foundation
import ComposableArchitecture

struct DataManager {
    var load: @Sendable (URL) throws -> Data
    var save: @Sendable (Data, URL) throws -> Void
}

extension DataManager: DependencyKey {
    
    struct SomeError: Error {}
    struct FileNotFoundError: Error {}
    
    static var liveValue = Self(
        load: { url in try Data(contentsOf: url)},
        save: { data, url in try data.write(to: url) }
    )
    
    static let previewValue = Self.mock()
    
    static let failToWrite = Self(
        load: { _ in Data() },
        save: { _, _ in
            throw SomeError()
        }
    )
    
    static let failToLoad = Self(
        load: { _ in
            throw SomeError()
        },
        save: { _, _ in }
    )
    
    static func mock(initalData: Data? = nil) -> Self {
        let data = LockIsolated(initalData)
        return Self(
            load: { _ in
                guard let data = data.value else {
                    throw FileNotFoundError()
                }
                return data
            },
            save: { newData, _ in
                data.setValue(newData)
            }
        )
    }
}

extension DependencyValues {
    var dataManager: DataManager {
        get { self[DataManager.self] }
        set { self[DataManager.self] = newValue }
    }
}
