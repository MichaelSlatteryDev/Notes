//
//  NotesFeature.swift
//  Notes
//
//  Created by Michael Slattery on 6/22/24.
//

import Foundation
import ComposableArchitecture
import SwiftUI

extension URL {
    static let notes = Self.documentsDirectory.appending(component: "notes.json")
}

@Reducer
struct NotesFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
        var notes: IdentifiedArrayOf<Note> = []
        
        init(destination: Destination.State? = nil) {
            self.destination = destination
            do {
                @Dependency(\.dataManager.load) var loadData
                self.notes = try JSONDecoder().decode(IdentifiedArrayOf<Note>.self, from: loadData(.notes))
            } catch {
                notes = []
            }
        }
    }
    
    enum Action {
        case addNoteTapped
        case editNoteTapped(Note)
        case deleteButtonTapped(Note.ID)
        case destination(PresentationAction<Destination.Action>)
    }
    
    @Dependency(\.uuid) var uuid
    @Dependency(\.dataManager.save) var saveData
    
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
            case .deleteButtonTapped(let id):
                state.notes.remove(id: id)
                return .run { [notes = state.notes] _ in
                    try self.saveData(JSONEncoder().encode(notes), .notes)
                }
            case .destination(.presented(.addNote(.delegate(.saveNote(let note))))):
                if let index = state.notes.firstIndex(of: note) {
                    state.notes[index] = note
                } else {
                    state.notes.append(note)
                }
                return .run { [notes = state.notes] _ in
                    try self.saveData(JSONEncoder().encode(notes), .notes)
                }
            case .destination:
                return .none
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
                    HStack {
                        HStack {
                            Text(note.title)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            store.send(.editNoteTapped(note))
                        }
                        
                        Button {
                            store.send(.deleteButtonTapped(note.id))
                        } label: {
                            Image(systemName: "trash")
                                .foregroundStyle(Color.red)
                        }
                        .padding(8)
                    }
                    .contentShape(Rectangle())
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
    }
}

#Preview {
    NotesView(store: Store(
        initialState: NotesFeature.State()) {
            NotesFeature()
        } withDependencies: {
            $0.dataManager = .mock(initalData: try? JSONEncoder().encode([Note(id: UUID(), title: "Title 1", body: "Foo"),
                                                                          Note(id: UUID(), title: "Title 2", body: "Bar"),
                                                                          Note(id: UUID(), title: "Title 3", body: "Test")]))
        }
    )
}
