//
//  ContactsFeatureTests.swift
//  NotesTests
//
//  Created by Michael Slattery on 6/16/24.
//

import ComposableArchitecture
import XCTest

@testable import Notes

final class ContactsFeatureTests: XCTestCase {
    
    @MainActor
    func testAddFlow() async {
        let store = TestStore(initialState: ContactsFeature.State()) {
            ContactsFeature()
        } withDependencies: {
            $0.uuid = .incrementing
        }
        
        await store.send(.addButtonTapped) { state in
            state.destination = .addContact(
                AddContactFeature.State(contact: .init(id: UUID(0), name: ""))
            )
        }
        
        await store.send(\.destination.addContact.setName, "Michael") {
            $0.destination?.addContact?.contact.name = "Michael"
        }
        
        await store.send(\.destination.addContact.saveButtonTapped)
        
        await store.receive(
            \.destination.addContact.delegate.saveContact,
             Contact(id: UUID(0), name: "Michael")
        ) {
            $0.contacts = [
                .init(id: UUID(0), name: "Michael")
            ]
        }
        
        await store.receive(\.destination.dismiss) {
            $0.destination = nil
        }
    }
    
    @MainActor
    func testAddFlow_NonExhaustive() async {
        let store = TestStore(initialState: ContactsFeature.State()) {
            ContactsFeature()
        } withDependencies: {
            $0.uuid = .incrementing
        }
        store.exhaustivity = .off
        
        await store.send(.addButtonTapped)
        await store.send(\.destination.addContact.setName, "Michael")
        await store.send(\.destination.addContact.saveButtonTapped)
        
        await store.skipReceivedActions()
        
        store.assert {
            $0.contacts = [
                .init(id: UUID(0), name: "Michael")
            ]
            $0.destination = nil
        }
    }
    
    @MainActor
    func testDeleteFlow_NonExhaustive() async {
        let store = TestStore(initialState: ContactsFeature.State(contacts: [
            .init(id: UUID(0), name: "Michael")
        ])) {
            ContactsFeature()
        } withDependencies: {
            $0.uuid = .incrementing
        }
        store.exhaustivity = .off
        
        await store.send(.deleteButtonTapped(UUID(0)))
        await store.send(\.destination.alert, .confirmDeletion(UUID(0)))
        
        store.assert {
            $0.contacts = []
            
            $0.destination = nil
        }
    }
}
