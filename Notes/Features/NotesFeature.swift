//
//  NotesFeature.swift
//  Notes
//
//  Created by Michael Slattery on 6/22/24.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct Note: Identifiable, Equatable {
    let id: UUID
    var title: String
    var body: String

    init(id: UUID, title: String, body: String) {
        self.id = id
        self.title = title
        self.body = body
    }

    static func == (lhs: Note, rhs: Note) -> Bool {
        lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.body == rhs.body
    }
}

@Reducer
struct NotesFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
        var notes: IdentifiedArrayOf<Note> = []
    }
    
    enum Action {
        case addNoteTapped
        case editNoteTapped(Note)
        case destination(PresentationAction<Destination.Action>)
//        case fetchNotes
    }
    
    @Dependency(\.uuid) var uuid
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addNoteTapped:
                state.destination = .addNote(
                    AddNotesFeature.State(note: .init(id: self.uuid(), title: "", body: ""))
                )
                return .none
            case .editNoteTapped(let note):
                state.destination = .addNote(
                    AddNotesFeature.State(note: .init(id: note.id, title: note.title, body: note.body))
                )
                return .none
            case .destination(.presented(.addNote(.delegate(.saveNote(let note))))):
                state.notes.append(note)
                return .none
            case .destination:
                return .none
//            case .fetchNotes:
//                let fetchResults = state.fetchNotes()
//                state.notes += fetchResults
//                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension NotesFeature {
    @Reducer(state: .equatable)
    enum Destination {
        case addNote(AddNotesFeature)
    }
}

struct NotesView: View {
    
    @Bindable var store: StoreOf<NotesFeature>
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(store.notes) { note in
                    Text(note.title)
                        .onTapGesture {
                            store.send(.editNoteTapped(note))
                        }
//                    HStack {
//                        Spacer()
//                        Button {
//                            store.send(.deleteButtonTapped(contact.id))
//                        } label: {
//                            Image(systemName: "trash")
//                                .foregroundStyle(Color.red)
//                        }
//                    }
                }
            }
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItem {
                    Button {
                        store.send(.addNoteTapped)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(item: $store.scope(state: \.destination?.addNote, action: \.destination.addNote)) { addNotesStore in
            NavigationStack {
                AddNotesView(store: addNotesStore)
            }
        }
//        .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
    }
}

#Preview {
    NotesView(store: Store(
        initialState: NotesFeature.State(
            notes: [.init(id: UUID(), title: "Title 1", body: "Foo"),
                    .init(id: UUID(), title: "Title 2", body: "Bar"),
                    .init(id: UUID(), title: "Title 3", body: "Test")])) {
        NotesFeature()
    })
}
