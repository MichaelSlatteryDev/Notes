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
        var user: User
        @Presents var destination: Destination.State?
        var notes: IdentifiedArrayOf<Note> = []
        var api: NotesAPI = NotesAPI()
        
        init(user: User, destination: Destination.State? = nil) {
            self.user = user
            self.destination = destination
            self.notes = IdentifiedArray(uniqueElements: user.notes)
        }
    }
    
    enum Action {
        case addNoteTapped
        case editNoteTapped(Note)
        case deleteButtonTapped(Note.ID)
        case destination(PresentationAction<Destination.Action>)
        case fetchNotes
        case notesFetched(IdentifiedArrayOf<Note>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addNoteTapped:
                state.destination = .addNote(
                    AddNotesFeature.State(note: .init(id: "", title: "", body: "", userId: state.user.id ?? ""))
                )
                return .none
            case .editNoteTapped(let note):
                state.destination = .addNote(
                    AddNotesFeature.State(note: .init(id: note.id, title: note.title, body: note.body, userId: state.user.id ?? ""))
                )
                return .none
            case .deleteButtonTapped(let id):
                guard let id else { return .none }
                
                state.notes.remove(id: id)
                return .run { [api = state.api] _ in
                    try await api.deleteNote(id: id)
                }
            case .destination(.presented(.addNote(.delegate(.saveNote(let note))))):
                if let index = state.notes.firstIndex(where: { $0.id == note.id }) {
                    state.notes[index] = note
                } else {
                    state.notes.insert(note, at: 0)
                }
                return .run { [notes = state.notes, api = state.api] _ in
                    if note == notes.first {
                        try await api.addNote(note)
                    } else {
                        try await api.updateNote(note)
                    }
                }
            case .destination:
                return .none
            case .fetchNotes:
                return .run { [api = state.api] send in
                    let notes = try await api.getNotes()
                    await send(.notesFetched(notes))
                }
            case .notesFetched(let notes):
                state.notes = notes
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
                                .font(.headline)
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
                        .accessibilityLabel("Delete note \(note.title)")
                    }
                    .contentShape(Rectangle())
                }
            }
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Refresh") {
                        store.send(.fetchNotes)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
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
        initialState: NotesFeature.State(user: .init(name: "Michael", password: "", notes: []))) {
            NotesFeature()
        } withDependencies: {
            $0.dataManager = .mock(initalData: try? JSONEncoder().encode([Note(id: "note1", title: "Title 1", body: "Foo", userId: "1"),
                                                                          Note(id: "note2", title: "Title 2", body: "Bar", userId: "1"),
                                                                          Note(id: "note3", title: "Title 3", body: "Test", userId: "1")]))
        }
    )
}