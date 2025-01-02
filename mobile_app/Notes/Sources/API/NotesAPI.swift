//
//  NotesAPI.swift
//  Notes
//
//  Created by Michael Slattery on 10/15/24.
//

import Foundation
import ComposableArchitecture

struct NotesAPI: Equatable {
    @Dependency(\.api) var api
    let endpoint: API.Endpoints = .notes

    func getNotes(for userId: String?) async throws -> IdentifiedArrayOf<Note> {
        let baseUrl = URL(string: endpoint.value)!

        let url = baseUrl.appending(queryItems: [
            URLQueryItem(name: "userId", value: userId)
        ])

        let request = URLRequest(url: url)

        let (data, _) = try await api.authorizedRequest(request)

        let notes = try JSONDecoder().decode(IdentifiedArrayOf<Note>.self, from: data)
        return notes
    }

    func addNote(_ note: Note) async throws {
        var request = URLRequest(url: URL(string: endpoint.value)!)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(note)

        _ = try await api.authorizedRequest(request)
    }

    func updateNote(_ note: Note) async throws {
        guard let noteId = note.id else { return }
        var request = URLRequest(url: URL(string: "\(endpoint.value)/\(noteId)")!)
        request.httpMethod = "PUT"
        request.httpBody = try JSONEncoder().encode(note)

        _ = try await api.authorizedRequest(request)
    }

    func deleteNote(id: String) async throws {
        var request = URLRequest(url: URL(string: "\(endpoint.value)/\(id)")!)
        request.httpMethod = "DELETE"

        _ = try await api.authorizedRequest(request)
    }
}

// MARK: Equatable

extension NotesAPI {
    static func == (lhs: NotesAPI, rhs: NotesAPI) -> Bool {
        lhs.endpoint == rhs.endpoint
    }
}
