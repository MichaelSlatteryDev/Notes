////
////  SwiftDataModelConfigurationProvider.swift
////  Notes
////
////  Created by Michael Slattery on 6/23/24.
////
//
//import Foundation
//import SwiftData
//
//final class SwiftDataModelConfigurationProvider {
//    
//    public static let shared = SwiftDataModelConfigurationProvider(isStoredInMemoryOnly: false, autosaveEnabled: true)
//    
//    // Properties to manage configuration options
//    private var isStoredInMemoryOnly: Bool
//    private var autosaveEnabled: Bool
//    
//    private init(isStoredInMemoryOnly: Bool, autosaveEnabled: Bool) {
//        self.isStoredInMemoryOnly = isStoredInMemoryOnly
//        self.autosaveEnabled = autosaveEnabled
//    }
//    
//    @MainActor
//    public lazy var container: ModelContainer = {
//        // Define schema and configuration
//        let schema = Schema(
//            [
//                Note.self
//            ]
//        )
//        
//        let configuration = ModelConfiguration(isStoredInMemoryOnly: isStoredInMemoryOnly)
//        
//        // Create ModelContainer with schema and configuration
//        let container = try! ModelContainer(for: schema, configurations: [configuration])
//        container.mainContext.autosaveEnabled = autosaveEnabled
//        return container
//    }()
//}
