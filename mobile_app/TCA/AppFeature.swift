//
//  AppFeature.swift
//  NotesTests
//
//  Created by Michael Slattery on 6/4/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct AppFeature {
    @ObservableState
    struct State: Equatable {
        var tab1 = CounterFeature.State()
        var tab2 = ContactsFeature.State()
    }

    enum Action {
        case tab1(CounterFeature.Action)
        case tab2(ContactsFeature.Action)
    }

    let tab1Id = UUID()

    var body: some ReducerOf<Self> {
        Scope(state: \.tab1, action: \.tab1) {
            CounterFeature(id: tab1Id)
        }

        Scope(state: \.tab2, action: \.tab2) {
            ContactsFeature()
        }

        Reduce { _, _ in
            .none
        }
    }
}

struct AppView: View {
    let store: StoreOf<AppFeature>

    var body: some View {
        TabView {
            CounterView(store: store.scope(state: \.tab1, action: \.tab1))
                .tabItem {
                    Text("Counter 1")
                }

            ContactsView(store: store.scope(state: \.tab2, action: \.tab2))
                .tabItem {
                    Text("Counter 2")
                }
        }
    }
}

#Preview {
    AppView(store: Store(initialState: AppFeature.State()) {
        AppFeature()
    })
}
