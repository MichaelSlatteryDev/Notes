//
//  RegisterFeature.swift
//  Notes
//
//  Created by Michael Slattery on 11/21/24.
//

import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
struct RegisterFeature {
    @ObservableState
    struct State: Equatable {}

    enum Action {}

    var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {}
        }
    }
}

struct RegisterView: View {
    @Bindable var store: StoreOf<RegisterFeature>

    var body: some View {
        Text("Hello World!")
    }
}
