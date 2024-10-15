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
        var user: User = User(name: "", password: "", notes: [])
        @Presents var destination: Destination.State?
    }
    
    enum Action {
        case loginButtonTapped
        case loginSuccess(User)
        case registerButtonTapped
        case registerSuccess
        case setUsername(String)
        case setPassword(String)
        case destination(PresentationAction<Destination.Action>)
    }
    
    @Dependency(\.api) var api
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .loginButtonTapped:
                return .run { [user = state.user] send in
                    var request = URLRequest(url: URL(string: API.Endpoints.login(user.name).value)!)
                    request.httpMethod = "POST"
                    
                    let (data, _) = try await api.authorizedRequest(request, user.name, user.password)
                    let authorizedUser = try JSONDecoder().decode(User.self, from: data)
                    await send(.loginSuccess(authorizedUser))
                } catch: { error, send in
                    print(error)
                }
            case .loginSuccess(let user):
                state.destination = .login(
                    NotesFeature.State(user: user)
                )
                return .none
            case .registerButtonTapped:
                return .run { [user = state.user] send in
                    var request = URLRequest(url: URL(string: API.Endpoints.register.value)!)
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
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension LoginFeature {
    @Reducer(state: .equatable)
    enum Destination {
        case login(NotesFeature)
    }
}

struct LoginView: View {
    
    @Bindable var store: StoreOf<LoginFeature>
    
    var body: some View {
        VStack(alignment: .center, spacing: 16.0) {
            TextField("Username", text: $store.user.name.sending(\.setUsername))
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            SecureField("Enter your password", text: $store.user.password.sending(\.setPassword))
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                store.send(.loginButtonTapped)
            },
            label: {
                Text("Log In")
            })
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            Button(action: {
                store.send(.registerButtonTapped)
            },
            label: {
                Text("Register")
            })
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .foregroundColor(Color.blue)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.blue, lineWidth: 1)
            )
                        
            // Optional: Add a "Forgot Password?" link
            Text("Forgot Password?")
                .foregroundColor(.blue)
                .onTapGesture {
                    // Handle password recovery
                }
        }
        .padding()
        .sheet(item: $store.scope(state: \.destination?.login, action: \.destination.login)) { noteStore in
            NavigationStack {
                NotesView(store: noteStore)
            }
        }
    }
}

#Preview {
    LoginView(store: Store(initialState: LoginFeature.State(user: .init(name: "", password: "", notes: []))) {
        LoginFeature()
    })
}
