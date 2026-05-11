//
//  AuthPopUp.swift
//  MealPrep
//
//  Created by Enerel Tsolmonbayar on 9/5/2026.
//

import SwiftUI

struct AuthPopupView: View {

    @Binding var showPopup: Bool

    var onLoginTap: () -> Void
    var onSignUpTap: () -> Void
    var onGuestTap: () -> Void

    var body: some View {

        ZStack {

            // Background Blur
            Color.black.opacity(0.25)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Button {
                    showPopup = false
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.secondary)
                        .frame(width: 34, height: 34)
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .accessibilityLabel("Close")

                ZStack(alignment: .bottomTrailing) {

                    Circle()
                        .fill(Color(hex: "#D7B58D"))
                        .frame(width: 220, height: 220)

                    Image("mealprep")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())

                    Circle()
                        .fill(Color.orange)
                        .frame(width: 60, height: 60)
                        .overlay {

                            Image(systemName: "fork.knife")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        .offset(x: 10, y: 10)
                }

                // MARK: - Title

                VStack(spacing: 12) {

                    Text("Join the MealPrep\nCommunity")
                        .font(.system(size: 34, weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(hex: "#F0A85A"))

                    Text("Sign in to save recipes, follow your favorite bloggers, and plan your whole week.")
                        .font(.system(size: 20))
                        .foregroundColor(.brown.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                // MARK: - Buttons

                VStack(spacing: 18) {

                    Button {

                        onLoginTap()

                    } label: {

                        Text("Log In")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(20)
                    }

                    Button {

                        onSignUpTap()

                    } label: {

                        Text("Sign Up")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.orange)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.orange, lineWidth: 2)
                            )
                    }

                    Button {

                        onGuestTap()
                        showPopup = false

                    } label: {

                        Text("Continue as Guest")
                            .font(.title3.weight(.medium))
                            .foregroundColor(.brown)
                    }
                }

                Divider()
                    .padding(.top, 10)

                Text("TRUSTED BY 50K+ HOME COOKS")
                    .font(.footnote)
                    .tracking(2)
                    .foregroundColor(.brown.opacity(0.6))
            }
            .padding(32)
            .frame(maxWidth: 650)
            .background(Color.white)
            .cornerRadius(30)
            .shadow(radius: 20)
            .padding()
        }
    }
}
