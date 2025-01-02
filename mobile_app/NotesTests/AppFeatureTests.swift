//
//  AppFeatureTests.swift
//  NotesTests
//
//  Created by Michael Slattery on 6/4/24.
//

import ComposableArchitecture
import XCTest

@testable import Notes

@MainActor
final class AppFeatureTests: XCTestCase {
    func testIncrementInFirstTab() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }

        await store.send(\.tab1.incrementButtonTapped) { state in
            state.tab1.count = 1
        }
    }
}
