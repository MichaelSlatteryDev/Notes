//
//  AddNotesFeature.swift
//  Notes
//
//  Created by Michael Slattery on 6/22/24.
//

import Foundation
import ComposableArchitecture
import SwiftUI

@Reducer
struct AddNotesFeature {
    @ObservableState
    struct State: Equatable {
        var note: Note
    }
    
    enum Action {
        @CasePathable
        enum Delegate {
            case saveNote(Note)
        }
        
        case cancelButtonTapped
        case delegate(Delegate)
        case saveButtonTapped
        case setDescription(String)
        case setTitle(String)
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .cancelButtonTapped:
                return .run { _ in await self.dismiss() }
            case .delegate:
                return .none
            case .saveButtonTapped:
                return .run { [note = state.note] send in
                    await send(.delegate(.saveNote(note)))
                    await self.dismiss()
                }
            case .setDescription(let body):
                state.note.body = body
                return .none
            case .setTitle(let title):
                state.note.title = title
                return .none
            }
        }
    }
}

struct AddNotesView: View {
    
    @Bindable var store: StoreOf<AddNotesFeature>
    
    var body: some View {
        VStack {
            TextField("Title", text: $store.note.title.sending(\.setTitle))
            TextEditor(text: $store.note.body.sending(\.setDescription))
        }
        .padding(.horizontal)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    store.send(.cancelButtonTapped)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    store.send(.saveButtonTapped)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddNotesView(store: Store(initialState: AddNotesFeature.State(note: Note(id: "note1", title: "Test", body: "Hello World!", userId: 1))) {
            AddNotesFeature()
        })
    }
}
