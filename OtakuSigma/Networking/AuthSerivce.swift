//
//  AuthSerivce.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/26/23.
//

import Foundation
import UIKit

protocol OAuthService {
    func showLogin()
    func refreshAccessTokenIfNeeded() async
}

class MALAuthService: OAuthService {
    var codeVerifier: String? = nil

    let clientID = "9e125d96227fd516e34636ecf192b7f6"
    let redirectURI = "myanimeapp://auth" // same value from mal redirect uri
    
    func showLogin() {
        print(#function)
        guard let authorizationURL = buildAuthorizationURL() else { return }    // creates codeVerifier
        UIApplication.shared.open(authorizationURL) // open myanimelist login
    }
    
    // Returns access token on success
    func handleLogin(url: URL) async -> TokenResponse? {
        guard let codeVerifier = codeVerifier else { return nil }
        return await generateAccessToken(from: url, codeVerifier: codeVerifier)
    }

    private func generateAccessToken(from url: URL, codeVerifier: String) async -> TokenResponse? {
        print(#function)
        // Capture the redirection and extract the authorization code
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let authorizationCode = components.queryItems?.first(where: { $0.name == "code" })?.value
        else {
            print("Fail to capture authorization code")
            return nil
        }

        let tokenRequest = AccessTokenAPIRequest(clientID: clientID, code: authorizationCode, codeVerifier: codeVerifier)
        
        do {
            let tokenResponse = try await sendRequest(tokenRequest)
            
            print("Expires in \(tokenResponse.expiresIn) seconds") // Expires in 30 days
            Settings.shared.accessToken = tokenResponse.accessToken
            Settings.shared.refreshToken = tokenResponse.refreshToken
            let firstTimeLogIn = Settings.shared.accessTokenLastUpdated == nil
            if firstTimeLogIn {
                // Initalize last updated to today
                Settings.shared.accessTokenLastUpdated = .now
            }
            return tokenResponse
        } catch {
            print("Erroring generating access token: \(error)")
            return nil
        }
    }
    
    private func buildAuthorizationURL() -> URL? {
        let codeVerifier = createCodeVerifier()
        self.codeVerifier = codeVerifier    // side effect: store and used to generate access token later
        let baseURLString = "https://myanimelist.net/v1/oauth2/authorize"
        
        var components = URLComponents(string: baseURLString)
        components?.queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "code_challenge", value: codeVerifier),
            URLQueryItem(name: "redirect_uri", value: redirectURI)
        ]
        
        let authorizationURL = components?.url
        return authorizationURL
    }
    
    // Note: Access Token lasts 1 hour. Refresh Token last ~30 days.
    // - Refresh token is used to create a new access token (and new refresh token?) which extends the user's session without them having to log in again.
    func refreshAccessTokenIfNeeded() async {
        print(#function)
        guard let refreshToken = Settings.shared.refreshToken,
              let tokenLastUpdated = Settings.shared.accessTokenLastUpdated
        else { return }
        
        do {
            print("User has access token")
            // Refresh access token (expires every month)
            let twoWeeks: TimeInterval = 14 * 86400
            let tokenExpirationDate = tokenLastUpdated.addingTimeInterval(twoWeeks)
            let isTokenExpired = tokenExpirationDate < .now
            if isTokenExpired {
                print("Token Expired...refreshing token")
                let refreshRequest = RefreshTokenAPIRequest(clientID: clientID, refreshToken: refreshToken)
                let tokenResponse = try await sendRequest(refreshRequest)
                print("Successfully refreshed token")
                // Update tokens with new values
                Settings.shared.accessToken = tokenResponse.accessToken
                Settings.shared.refreshToken = tokenResponse.refreshToken
                Settings.shared.accessTokenLastUpdated = .now
            } else {
                print("Token is not expired")
            }
        } catch {
            print("Error refreshing access token: \(error)")
        }
    }
    
    private func createCodeVerifier() -> String {
        let length = 128
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~"
        
        var codeVerifier = ""
        
        for _ in 0..<length {
            let randomIndex = Int(arc4random_uniform(UInt32(allowedChars.count)))
            let randomChar = allowedChars[String.Index(utf16Offset: randomIndex, in: allowedChars)]
            codeVerifier.append(randomChar)
        }

        return codeVerifier
    }

}
