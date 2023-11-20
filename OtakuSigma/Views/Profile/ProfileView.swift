//
//  SettingsView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/1/23.
//

import SwiftUI

struct ProfileView: View {
        @EnvironmentObject var profileViewModel: ProfileViewModel
        @Environment(\.openURL) private var openURL
    
        var body: some View {
            VStack {
                if profileViewModel.authService.isLoggedIn {
                    Button("Log Out") {
                        print("log out")
                    }
                } else {
                    Button("Login") {
                        profileViewModel.loginButtonTapped()
                    }
                }
            }
            .onOpenURL { url in
                Task {
                    await profileViewModel.generateAccessToken(from: url)
                }
            }
        }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
