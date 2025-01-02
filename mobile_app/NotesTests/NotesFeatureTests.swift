//
//  NotesFeatureTests.swift
//  NotesTests
//
//  Created by Michael Slattery on 5/31/24.
//

import ComposableArchitecture
import XCTest

@testable import Notes

final class NotesFeatureTests: XCTestCase {
    @MainActor
    func testAddFlow_NonExhaustive() async {
        let store = TestStore(initialState: NotesFeature.State()) {
            NotesFeature()
        } withDependencies: {
            $0.uuid = .incrementing
            $0.dataManager = .mock()
        }
        store.exhaustivity = .off

        await store.send(.addNoteTapped)
        await store.send(\.destination.addNote.setTitle, "Food")
        await store.send(\.destination.addNote.saveButtonTapped)

        await store.skipReceivedActions()

        store.assert {
            $0.notes = [
                Note(id: "0", title: "Food", body: ""),
            ]
            $0.destination = nil
        }
    }

    @MainActor
    func testDeleteFlow_NonExhaustive() async {
        let store = TestStore(initialState: NotesFeature.State()) {
            NotesFeature()
        } withDependencies: {
            $0.uuid = .incrementing
            let notes: [Note] = [Note(id: "0", title: "Food", body: "")]
            $0.dataManager = .mock(initalData: try? JSONEncoder().encode(notes))
        }
        store.exhaustivity = .off

        await store.send(.deleteButtonTapped("0"))

        store.assert {
            $0.notes = []
        }
    }
}
