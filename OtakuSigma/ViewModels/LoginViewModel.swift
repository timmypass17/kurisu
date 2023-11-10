//
//  LoginViewModel.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/25/23.
//

import Foundation
import UIKit

class LoginViewModel: ObservableObject {

    let authService: OAuthService
    
    init(authService: OAuthService) {
        self.authService = authService
    }
    
    func authorizeButtonTapped() {
        guard let authorizationURL = authService.buildAuthorizationURL() else { return }
        UIApplication.shared.open(authorizationURL)
    }
    
    func generateAccessToken(from url: URL) async {
        guard let codeVerifier = authService.codeVerifier else { return }
        await authService.generateAccessToken(from: url, codeVerifier: codeVerifier)
    }
}
