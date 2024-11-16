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
        @Presents var destination: Destination.State?
        var loading: Bool?
        
        init(user: User? = nil) {
            if let user = user {
                self.user = user
                return
            }
            
            if let username = UserDefaults.standard.string(forKey: "Username"),
               let password = keychain.get(.password) {
                self.user = User(name: username, password: password, notes: [])
            } else {
                self.user = User(name: "", password: "", notes: [])
            }
        }
    }
    
    enum Action {
        case login
        case loginSuccess(User)
        case loginFailed
        case registerButtonTapped
        case registerSuccess
        case setUsername(String)
        case setPassword(String)
        case destination(PresentationAction<Destination.Action>)
    }
    
    @Dependency(\.api) var api
    @Dependency(\.keychainManager) static var keychain
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .login:
                state.loading = true
                return .run { [user = state.user] send in
                    let action = await loginRequest(for: user)
                    await send(action)
                } catch: { error, send in
                    print(error)
                    clearStoredUserData()
                }
            case .loginSuccess(let user):
                state.destination = .login(
                    NotesFeature.State(user: user)
                )
                state.user = User()
                state.loading = false
                return .none
            case .loginFailed:
                state.loading = false
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
    
    private func loginRequest(for user: User) async -> Action {
        guard !user.name.isEmpty && !user.password.isEmpty else { return .loginFailed }
            
        var request = URLRequest(url: URL(string: API.Endpoints.login(user.name).value)!)
        request.httpMethod = "POST"
        
//        if UserDefaults.standard.string(forKey: "Username") == nil {
        UserDefaults.standard.set(user.name, forKey: "Username")
//        }
        
        do {
            if Self.keychain.get(.password) == nil {
                try Self.keychain.add(.password, user.password)
            } else {
                try Self.keychain.update(.password, user.password)
            }
            
            let (data, _) = try await api.authorizedRequest(request)
            let authorizedUser = try JSONDecoder().decode(User.self, from: data)
            return .loginSuccess(authorizedUser)
        } catch(let error) {
            print(error)
            return .loginFailed
        }
    }
    
    private func clearStoredUserData() {
        do {
            UserDefaults.standard.removeObject(forKey: "Username")
            try Self.keychain.delete(.password)
        } catch(let error) {
            print(error)
        }
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
        ZStack {
            if store.state.loading == true {
                ProgressView()
            } else {
                VStack(alignment: .center, spacing: 16.0) {
                    TextField("Username", text: $store.user.name.sending(\.setUsername))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    SecureField("Enter your password", text: $store.user.password.sending(\.setPassword))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        store.send(.login)
                    }, label: {
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
                    
                    Text("Forgot Password?")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            // Handle password recovery
                        }
                }
                .padding()
                .fullScreenCover(item: $store.scope(state: \.destination?.login, action: \.destination.login)) { noteStore in
                    NavigationStack {
                        NotesView(store: noteStore)
                    }
                }
            }
        }
        .onAppear {
            store.send(.login)
        }
    }
}

#Preview {
    LoginView(store: Store(initialState: LoginFeature.State(user: .init(name: "", password: "", notes: []))) {
        LoginFeature()
    })
}
