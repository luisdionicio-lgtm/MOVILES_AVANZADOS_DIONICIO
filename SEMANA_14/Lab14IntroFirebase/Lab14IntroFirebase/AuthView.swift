//
//  AuthView.swift
//  Lab14IntroFirebase
//@
//  Created by Luis DB on 19/11/26.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore

struct AuthView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isSignedIn = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var authStateListener: AuthStateDidChangeListenerHandle?

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Lab 14: Firebase")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)

                Spacer()

                if isSignedIn {
                    MessagesView()
                } else {
                    VStack(spacing: 15) {
                        TextField("Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)

                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        HStack(spacing: 20) {
                            Button("Sign In") {
                                signIn()
                            }
                            .buttonStyle(PrimaryButtonStyle())

                            Button("Sign Up") {
                                signUp()
                            }
                            .buttonStyle(SecondaryButtonStyle())
                        }
                    }
                    .padding(.horizontal, 30)
                }

                Spacer()
            }
            .navigationBarHidden(true)
        }
        .alert("Message", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
        .onAppear {
            checkAuthState()
        }
        .onChange(of: isSignedIn) { _, signedIn in
            if !signedIn {
                email = ""
                password = ""
            }
        }
        .onDisappear {
            if let authStateListener {
                Auth.auth().removeStateDidChangeListener(authStateListener)
                self.authStateListener = nil
            }
        }
    }

    // MARK: - Authentication Functions

    private func signIn() {
        guard !email.isEmpty && !password.isEmpty else {
            alertMessage = "Please enter both email and password"
            showAlert = true
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error {
                alertMessage = "Sign in failed: \(error.localizedDescription)"
                showAlert = true
                print("error.localizedDescription: \(error.localizedDescription)")
            } else {
                isSignedIn = true
                alertMessage = "Sign in successful!"
                showAlert = true
            }
        }
    }

    private func signUp() {
        guard !email.isEmpty && !password.isEmpty else {
            alertMessage = "Please enter both email and password"
            showAlert = true
            return
        }

        guard password.count >= 6 else {
            alertMessage = "Password must be at least 6 characters"
            showAlert = true
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if let error {
                alertMessage = "Sign up failed: \(error.localizedDescription)"
                showAlert = true
            } else {
                isSignedIn = true
                alertMessage = "Account created successfully!"
                showAlert = true
            }
        }
    }

    private func signOut() {
        do {
            try Auth.auth().signOut()
            isSignedIn = false
            alertMessage = "Signed out successfully"
            showAlert = true
        } catch {
            alertMessage = "Sign out failed: \(error.localizedDescription)"
            showAlert = true
        }
    }

    private func checkAuthState() {
        guard authStateListener == nil else { return }

        authStateListener = Auth.auth().addStateDidChangeListener { _, user in
            isSignedIn = user != nil
        }
    }
}

// MARK: - Button Styles

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.blue)
            .padding()
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.blue, lineWidth: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct SignOutButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(Color.red)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

#Preview {
    AuthView()
}
