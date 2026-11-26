//
//  DatabaseService.swift
//  Lab14IntroFirebase
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

struct Message: Identifiable, Codable {
    let id: String
    let text: String
    let userEmail: String
    let timestamp: Date
}

@MainActor
final class DatabaseService: ObservableObject {
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    @Published var messages: [Message] = []

    func addMessage(text: String) {
        guard let user = Auth.auth().currentUser else { return }

        let message = Message(
            id: UUID().uuidString,
            text: text,
            userEmail: user.email ?? "Unknown",
            timestamp: Date()
        )

        do {
            try db.collection("messages")
                .document(message.id)
                .setData(from: message)
        } catch {
            print("Error adding message: \(error.localizedDescription)")
        }
    }

    func startListening() {
        guard listener == nil else { return }

        listener = db.collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { [weak self] querySnapshot, error in
                if let error {
                    print("Error getting messages: \(error.localizedDescription)")
                    return
                }

                let messages = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: Message.self)
                } ?? []

                Task { @MainActor in
                    self?.messages = messages
                }
            }
    }

    func stopListening() {
        listener?.remove()
        listener = nil
    }
}
