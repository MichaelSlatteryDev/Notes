//
//  ContactsFeature.swift
//  NotesTests
//
//  Created by Michael Slattery on 6/8/24.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct Contact: Identifiable, Equatable {
    let id: UUID
    var name: String
}

@Reducer
struct ContactsFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
        var contacts: IdentifiedArrayOf<Contact> = []
    }

    enum Action {
        enum Alert: Equatable {
            case confirmDeletion(Contact.ID)
        }

        case addButtonTapped
        case deleteButtonTapped(Contact.ID)
        case destination(PresentationAction<Destination.Action>)
    }

    @Dependency(\.uuid) var uuid

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.destination = .addContact(
                    AddContactFeature.State(
                        contact: .init(id: self.uuid(), name: "")
                    )
                )
                return .none
            case let .deleteButtonTapped(id):
                state.destination = .alert(
                    AlertState.deleteConfirmation(id: id)
                )
                return .none
            case let .destination(.presented(.addContact(.delegate(.saveContact(contact))))):
                state.contacts.append(contact)
                return .none
            case let .destination(.presented(.alert(.confirmDeletion(id)))):
                state.contacts.remove(id: id)
                return .none
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension ContactsFeature {
    @Reducer(state: .equatable)
    enum Destination {
        case addContact(AddContactFeature)
        case alert(AlertState<ContactsFeature.Action.Alert>)
    }
}

extension AlertState where Action == ContactsFeature.Action.Alert {
    static func deleteConfirmation(id: UUID) -> Self {
        Self {
            TextState("Are you sure?")
        } actions: {
            ButtonState(role: .destructive, action: .confirmDeletion(id)) {
                TextState("Delete")
            }
        }
    }
}

struct ContactsView: View {
    @Bindable var store: StoreOf<ContactsFeature>

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.contacts) { contact in
                    HStack {
                        Text(contact.name)
                        Spacer()
                        Button {
                            store.send(.deleteButtonTapped(contact.id))
                        } label: {
                            Image(systemName: "trash")
                                .foregroundStyle(Color.red)
                        }
                    }
                }
            }
            .navigationTitle("Contacts")
            .toolbar {
                ToolbarItem {
                    Button {
                        store.send(.addButtonTapped)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(item: $store.scope(state: \.destination?.addContact, action: \.destination.addContact)) { addContactStore in
            NavigationStack {
                AddContactView(store: addContactStore)
            }
        }
        .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
    }
}

#Preview {
    ContactsView(store: Store(
        initialState: ContactsFeature.State(
            contacts: [.init(id: UUID(), name: "Foo"),
                       .init(id: UUID(), name: "Bar"),
                       .init(id: UUID(), name: "Test")]))
    {
        ContactsFeature()
    })
}
