////
////  NoteDatabase.swift
////  Notes
////
////  Created by Michael Slattery on 6/23/24.
////
//
//import ComposableArchitecture
//import SwiftData
//
//public extension DependencyValues {
//    var noteDatabase: NoteDatabase {
//        get { self[NoteDatabase.self] }
//        set { self[NoteDatabase.self] = newValue }
//    }
//}
//
//public struct NoteDatabase {
//    public var fetchAll: @Sendable () throws -> [Note]
//    public var fetch: @Sendable (FetchDescriptor<Note>) throws -> [Note]
//    public var fetchCount: @Sendable (FetchDescriptor<Note>) throws -> Int
//    public var add: @Sendable (Note) throws -> Void
//    public var delete: @Sendable (Note) throws -> Void
//    public var save: @Sendable () throws -> Void
//    
//    enum NoteError: Error {
//        case add
//        case delete
//        case save
//    }
//}
//
//extension NoteDatabase: DependencyKey {
//    public static let liveValue = Self(
//        fetchAll: {
//            // Fetch all notes from the database
//            do {
//                @Dependency(\.databaseService.context) var context
//                let noteContext = try context()
//                
//                let descriptor = FetchDescriptor<Note>()
//                return try noteContext.fetch(descriptor)
//            } catch {
//                return []
//            }
//        }, fetch: { descriptor in
//            // Fetch notes based on descriptor criteria
//            do {
//                @Dependency(\.databaseService.context) var context
//                let noteContext = try context()
//                return try noteContext.fetch(descriptor)
//            } catch {
//                return []
//            }
//        }, fetchCount: { descriptor in
//            // Fetch count of notes based on descriptor criteria
//            do {
//                @Dependency(\.databaseService.context) var context
//                let noteContext = try context()
//                return try noteContext.fetchCount(descriptor)
//            } catch {
//                return 0
//            }
//        }, add: { model in
//            // Add a note to the database
//            do {
//                @Dependency(\.databaseService.context) var context
//                let noteContext = try context()
//                
//                noteContext.insert(model)
//            } catch {
//                
//            }
//        }, delete: { model in
//            // Delete a note from the database
//            do {
//                @Dependency(\.databaseService.context) var context
//                let noteContext = try context()
//                
//                noteContext.delete(model)
//            } catch {
//                
//            }
//        }, save: {
//            // Save changes to the database
//            do {
//                @Dependency(\.databaseService.context) var context
//                let noteContext = try context()
//                
//                try noteContext.save()
//            } catch {
//                
//            }
//        }
//    )
//}
