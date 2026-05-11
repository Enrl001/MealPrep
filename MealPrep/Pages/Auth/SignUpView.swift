//
//  SignUpView.swift
//  MealPrep
//
//  Created by Enerel Tsolmonbayar on 9/5/2026.
//

import SwiftUI

struct SignupView: View {

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authVM: AuthViewModel
    @State private var isPasswordVisible: Bool = false
    @State private var agreedToTerms: Bool = false

    var onLoginTap: (() -> Void)?

    var body: some View {

        ScrollView {
            VStack(spacing: 0) {
                closeButton
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal, 16)
                    .padding(.top, 12)

                // MARK: - Logo & Header
                VStack(spacing: 12) {

                    // Logo
                    HStack(spacing: 6) {
                        Image(systemName: "fork.knife.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(Color.orange)
                        Text("MealPrep")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.primary)
                    }
                    .padding(.top, 40)

                    Text("Create Account")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.primary)

                    Text("Start your journey to organized, delicious\nhome cooking today.")
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)

                // MARK: - Form Fields
                VStack(spacing: 16) {

                    // Full Name
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Full Name")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.primary)

                        HStack {
                            Image(systemName: "person")
                                .foregroundColor(.secondary)
                                .frame(width: 20)
                            TextField("Enter your full name", text: $authVM.signupName)
                                .autocapitalization(.words)
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 13)
                        .background(Color(.systemBackground))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                        .cornerRadius(10)
                    }

                    // Email
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Email")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.primary)

                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(.secondary)
                                .frame(width: 20)
                            TextField("chef@example.com", text: $authVM.signupEmail)
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 13)
                        .background(Color(.systemBackground))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                        .cornerRadius(10)
                    }

                    // Password
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Password")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.primary)

                        HStack {
                            Image(systemName: "lock")
                                .foregroundColor(.secondary)
                                .frame(width: 20)

                            if isPasswordVisible {
                                TextField("Min. 8 characters", text: $authVM.signupPassword)
                            } else {
                                SecureField("Min. 8 characters", text: $authVM.signupPassword)
                            }

                            Button {
                                isPasswordVisible.toggle()
                            } label: {
                                Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 13)
                        .background(Color(.systemBackground))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                        .cornerRadius(10)
                    }

                    // Terms & Privacy
                    HStack(alignment: .top, spacing: 10) {
                        Button {
                            agreedToTerms.toggle()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(agreedToTerms ? Color.orange : Color(.systemGray3), lineWidth: 1.5)
                                    .frame(width: 18, height: 18)
                                if agreedToTerms {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(.orange)
                                }
                            }
                        }
                        .padding(.top, 2)

                        Text("I agree to the \(Text("Terms").foregroundColor(.orange).underline()) and \(Text("Privacy Policy").foregroundColor(.orange).underline())")
                            .foregroundColor(.secondary)
                            .font(.system(size: 14))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 24)

                // MARK: - Get Started Button
                Button {
                    authVM.signUp()
                } label: {
                    Text("Get Started")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.orange)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)

                // MARK: - Error Message
                if !authVM.errorMessage.isEmpty {
                    Text(authVM.errorMessage)
                        .font(.system(size: 14))
                        .foregroundColor(.red)
                        .padding(.horizontal, 24)
                        .padding(.top, 8)
                }

                // MARK: - Login Link
                HStack(spacing: 4) {
                    Text("Already have an account?")
                        .foregroundColor(.secondary)
                    Button {
                        onLoginTap?()
                    } label: {
                        Text("Login")
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
