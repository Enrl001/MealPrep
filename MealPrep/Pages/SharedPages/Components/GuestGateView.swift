//
//  GuestGateView.swift
//  
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//

import SwiftUI

struct GuestGateView: View {
    let action: String
    @Binding var isPresented: Bool
    @EnvironmentObject var authVM: AuthViewModel
    @State private var showLogin = false
    @State private var showSignUp = false
    
    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            
            // Handle
            RoundedRectangle(cornerRadius: Theme.Radius.pill)
                .fill(Theme.Colors.divider)
                .frame(width: 40, height: 4)
                .padding(.top, Theme.Spacing.sm)
            
            // Icon
            ZStack {
                Circle()
                    .fill(Theme.Colors.primaryLight)
                    .frame(width: 80, height: 80)
                Image(systemName: "fork.knife.circle.fill")
                    .foregroundStyle(Theme.Colors.primary)
                    .font(.system(size: 40))
            }
            
            // Text
            VStack(spacing: Theme.Spacing.xs) {
                Text("Join MealPrep")
                    .font(Theme.Typography.hero)
                    .foregroundStyle(Theme.Colors.textPrimary)
                Text("Sign in or create an account to \(action)")
                    .font(Theme.Typography.body)
                    .foregroundStyle(Theme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            // Buttons
            VStack(spacing: Theme.Spacing.sm) {
                Button {
                    showLogin = true
                } label: {
                    Text("Log In")
                        .font(Theme.Typography.subhead)
                        .foregroundStyle(Theme.Colors.background)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Theme.Spacing.sm)
                        .background(Theme.Colors.primary)
                        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.pill))
                }
                
                Button {
                    showSignUp = true
                } label: {
                    Text("Sign Up")
                        .font(Theme.Typography.subhead)
                        .foregroundStyle(Theme.Colors.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Theme.Spacing.sm)
                        .background(Theme.Colors.background)
                        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.pill))
                        .overlay {
                            RoundedRectangle(cornerRadius: Theme.Radius.pill)
                                .stroke(Theme.Colors.primary, lineWidth: 1.5)
                        }
                }
                
                Button {
                    isPresented = false
                } label: {
                    Text("Maybe later")
                        .font(Theme.Typography.body)
                        .foregroundStyle(Theme.Colors.textSecondary)
                }
            }
            .padding(.horizontal, Theme.Spacing.md)
            
            Spacer()
        }
        .padding(Theme.Spacing.md)
        .background(Theme.Colors.background)
        .fullScreenCover(isPresented: $showLogin) {
            LoginView(onSignUpTap: {
                showLogin = false
                showSignUp = true
            })
            .environmentObject(authVM)
        }
        .fullScreenCover(isPresented: $showSignUp) {
            SignupView(onLoginTap: {
                showSignUp = false
                showLogin = true
            })
            .environmentObject(authVM)
        }
    }
}

#Preview {
    GuestGateView(action: "like recipes", isPresented: .constant(true))
        .environmentObject(AuthViewModel())
}
