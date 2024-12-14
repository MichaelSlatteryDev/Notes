//
//  RegisterFeature.swift
//  Notes
//
//  Created by Michael Slattery on 11/21/24.
//

import Foundation
import ComposableArchitecture
import SwiftUI

@Reducer
struct RegisterFeature {
    @ObservableState
    struct State: Equatable {
        
    }
    
    enum Action {
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            }
        }
    }
}

struct RegisterView: View {
    
    @Bindable var store: StoreOf<RegisterFeature>
    
    var body: some View {
        Text("Hello World!")
    }
}
