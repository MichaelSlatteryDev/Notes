////
////  Database.swift
////  Notes
////
////  Created by Michael Slattery on 6/23/24.
////
//
// import ComposableArchitecture
// import SwiftData
//
// extension DependencyValues {
//    var databaseService: Database {
//        get { self[Database.self] }
//        set { self[Database.self] = newValue }
//    }
// }
//
// struct Database {
//    var context: () throws -> ModelContext
// }
//
// extension Database: DependencyKey {
//    @MainActor
//    public static let liveValue = Self(
//        context: { appContext }
//    )
// }
//
// @MainActor
// let appContext: ModelContext = {
//    let container = SwiftDataModelConfigurationProvider.shared.container
//    let context = ModelContext(container)
//    return context
// }()
