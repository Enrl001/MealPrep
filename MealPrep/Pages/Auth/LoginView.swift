//
//  LoginView.swift
//  MealPrep
//
//  Created by Enerel Tsolmonbayar on 9/5/2026.
//

import SwiftUI

struct LoginView: View {

    @EnvironmentObject var authVM: AuthViewModel
    @State private var isPasswordVisible: Bool = false

    var onSignUpTap: (() -> Void)?

    var body: some View {

        ScrollView {
            VStack(spacing: 0) {

                // MARK: - Hero Image
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

                // MARK: - Tagline
                Text("Start your culinary journey.")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                    .padding(.bottom, 24)

                // MARK: - Welcome Header
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

                // MARK: - Form Fields
                VStack(spacing: 14) {

                    // Email
                    TextField("Email Address", text: $authVM.loginEmail)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
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
                            TextField("Password", text: $authVM.loginPassword)
                        } else {
                            SecureField("Password", text: $authVM.loginPassword)
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

                // MARK: - Forgot Password
//                Button {
//                    // Handle forgot password
//                } label: {
//                    Text("Forgot Password?")
//                        .font(.system(size: 14, weight: .medium))
//                        .foregroundColor(.orange)
//                }
//                .frame(maxWidth: .infinity, alignment: .trailing)
//                .padding(.horizontal, 24)
//                .padding(.top, 10)

                // MARK: - Login Button
                Button {
                    authVM.login()
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

                // MARK: - Error Message
                if !authVM.errorMessage.isEmpty {
                    Text(authVM.errorMessage)
                        .font(.system(size: 14))
                        .foregroundColor(.red)
                        .padding(.horizontal, 24)
                        .padding(.top, 8)
                }

                // MARK: - Sign Up Link
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
    }
}
