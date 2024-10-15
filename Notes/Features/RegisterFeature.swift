//
//  RegisterFeature.swift
//  Notes
//
//  Created by Michael Slattery on 10/10/24.
//

import Foundation
import ComposableArchitecture
import SwiftUI

@Reducer
struct RegisterFeature {
    @ObservableState
    struct State: Equatable {
        var user: User
    }
    
    enum Action {
        case registerButtonTapped
        case registerSuccess
        case setUsername(String)
        case setPassword(String)
    }
    
    @Dependency(\.api) var api
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .registerButtonTapped:
                return .run { [user = state.user] send in
                    var request = URLRequest(url: URL(string: API.Endpoints.register.rawValue)!)
                    request.httpMethod = "POST"
                    
                    let jsonData = try? JSONEncoder().encode(user)
                    request.httpBody = jsonData
                    
                    let _ = try await api.request(request)
                    await send(.registerSuccess)
                }
            case .registerSuccess:
                return .none
            case .setUsername(let name):
                state.user.name = name
                return .none
            case .setPassword(let password):
                state.user.password = password
                return .none
            }
        }
    }
}

struct RegisterView: View {
    
    @Bindable var store: StoreOf<RegisterFeature>
    
    var body: some View {
        VStack {
            TextField("Username", text: $store.user.name.sending(\.setUsername))
            TextField("Password", text: $store.user.password.sending(\.setUsername))
            Button(action: {
                store.send(.registerButtonTapped)
            },
            label: {
                Text("Register")
            })
        }
        .padding()
    }
}

#Preview {
    RegisterView(store: Store(initialState: RegisterFeature.State(user: .init(name: "", password: "", notes: []))) {
        RegisterFeature()
    })
}
