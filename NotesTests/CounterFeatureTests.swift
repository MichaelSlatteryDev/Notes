//
//  CounterFeatureTests.swift
//  NotesTests
//
//  Created by Michael Slattery on 6/4/24.
//

import ComposableArchitecture
import XCTest

@testable import Notes

@MainActor
final class CounterFeatureTests: XCTestCase {
    func testCounter() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature(id: UUID())
        }
        
        await store.send(.incrementButtonTapped, assert: { state in
            state.count = 1
        })
        
        await store.send(.decrementButtonTapped, assert: { state in
            state.count = 0
        })
    }
    
    func testTimer() async {
        let clock = TestClock()
        
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature(id: UUID())
        } withDependencies: { dependency in
            dependency.continuousClock = clock
        }
        
        await store.send(.toggleTimerButtonTapped, assert: { state in
            state.isTimerRunning = true
        })
        
        await clock.advance(by: .seconds(1))
        
        await store.receive(\.timerTick) { state in
            state.count = 1
        }
        
        await store.send(.toggleTimerButtonTapped, assert: { state in
            state.isTimerRunning = false
        })
    }
    
    func testNumberFact() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature(id: UUID())
        } withDependencies: { dependency in
            dependency.numberFact.fetch = { "\($0) is a cool number" }
        }
        
        await store.send(.factButtonTapped, assert: { state in
            state.isLoading = true
        })
        
        await store.receive(\.factResponse) { state in
            state.isLoading = false
            state.fact = "0 is a cool number"
        }
    }
}
