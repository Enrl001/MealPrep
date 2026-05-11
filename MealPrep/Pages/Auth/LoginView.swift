//
//  LoginView.swift
//  MealPrep
//
//  Created by Enerel Tsolmonbayar on 9/5/2026.
//

import SwiftUI

struct LoginView: View {

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authVM: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible: Bool = false

    var onSignUpTap: (() -> Void)?

    var body: some View {

        ScrollView {
            VStack(spacing: 0) {
                closeButton
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal, 16)
                    .padding(.top, 12)

                ZStack(alignment: .bottomLeading) {
                    // Hero food image
                    Image("mealprep")
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 220)
                        .clipped()

                    HStack(spacing: 6) {
                        Image(systemName: "fork.knife.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.orange)
                        Text("MealPrep")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.systemBackground).opacity(0.95))
                    )
                    .padding(.leading, 16)
                    .padding(.bottom, 40)
                }

                Text("Start your culinary journey.")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                    .padding(.bottom, 24)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Welcome back")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.primary)

                    Text("Sign in to continue your healthy habits.")
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.bottom, 24)

                VStack(spacing: 14) {

                    // Email
                    TextField("Email Address", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .textContentType(.username)
                        .autocorrectionDisabled()
                        .padding(.horizontal, 16)
                        .padding(.vertical, 15)
                        .background(Color(.systemBackground))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                        .cornerRadius(10)

                    // Password
                    HStack {
                        if isPasswordVisible {
                            TextField("Password", text: $password)
                                .textContentType(.password)
                                .autocorrectionDisabled()
                        } else {
                            SecureField("Password", text: $password)
                                .textContentType(.password)
                        }
                        Button {
                            isPasswordVisible.toggle()
                        } label: {
                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 15)
                    .background(Color(.systemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                    .cornerRadius(10)
                }
                .padding(.horizontal, 24)

                Button {
                    authVM.login(email: email, password: password)
                } label: {
                    Text("Login")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.orange)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                if !authVM.errorMessage.isEmpty {
                    Text(authVM.errorMessage)
                        .font(.system(size: 14))
                        .foregroundColor(.red)
                        .padding(.horizontal, 24)
                        .padding(.top, 8)
                }

                HStack(spacing: 4) {
                    Text("Don't have an account?")
                        .foregroundColor(.secondary)
                    Button {
                        onSignUpTap?()
                    } label: {
                        Text("Sign up")
                            .foregroundColor(.orange)
                            .fontWeight(.semibold)
                    }
                }
                .font(.system(size: 14))
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
        }
        .background(Color(.systemGroupedBackground))
        .onAppear {
            email = authVM.loginEmail
            password = authVM.loginPassword
        }
        .onChange(of: authVM.currentUser?.id) { _, userID in
            if userID != nil {
                dismiss()
            }
        }
    }

    private var closeButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.secondary)
                .frame(width: 34, height: 34)
                .background(Color(.systemBackground))
                .clipShape(Circle())
        }
        .accessibilityLabel("Close")
    }
}
