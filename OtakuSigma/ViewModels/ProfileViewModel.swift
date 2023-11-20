//
//  ProfileViewModel.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/25/23.
//

import Foundation
import UIKit

class ProfileViewModel: ObservableObject {
    @Published var isLoggedIn = false
    
    let authService: OAuthService
    
    init(authService: OAuthService) {
        self.authService = authService
    }
    
    func loginButtonTapped() {
        guard let authorizationURL = authService.buildAuthorizationURL() else { return }
        UIApplication.shared.open(authorizationURL) // open myanimelist login
    }
    
    func generateAccessToken(from url: URL) async {
        guard let codeVerifier = authService.codeVerifier else { return }
        await authService.generateAccessToken(from: url, codeVerifier: codeVerifier)
    }
}
