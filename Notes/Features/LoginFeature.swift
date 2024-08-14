//
//  LoginFeature.swift
//  Notes
//
//  Created by Michael Slattery on 8/14/24.
//

import Foundation
import ComposableArchitecture
import SwiftUI

@Reducer
struct LoginFeature {
    @ObservableState
    struct State: Equatable {
        var user: User
    }
    
    enum Action {
        case loginButtonTapped
        case loginSuccess
        case setUsername(String)
        case setPassword(String)
    }
    
    @Dependency(\.api) var api
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .loginButtonTapped:
                return .run { [user = state.user] send in
                    let request = URLRequest(url: URL(string: API.Endpoints.login.rawValue)!)
                    let _ = try await api.request(request)
                    await send(.loginSuccess)
                }
            case .loginSuccess:
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

struct LoginView: View {
    
    @Bindable var store: StoreOf<LoginFeature>
    
    var body: some View {
        VStack {
            TextField("Username", text: $store.user.name.sending(\.setUsername))
            TextField("Password", text: $store.user.password.sending(\.setUsername))
            Button(action: {
                store.send(.loginButtonTapped)
            },
            label: {
                Text("Log In")
            })
        }
        .padding()
    }
}

#Preview {
    LoginView(store: Store(initialState: LoginFeature.State(user: .init(name: "", password: ""))) {
        LoginFeature()
    })
}
