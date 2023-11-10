//
//  AuthSerivce.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/26/23.
//

import Foundation

protocol OAuthService {
    var codeVerifier: String? { get set }
    func generateAccessToken(from url: URL, codeVerifier: String) async
    func buildAuthorizationURL() -> URL?
    func refreshAccessToken() async
}

class MALAuthService: OAuthService {
    var codeVerifier: String?

    let clientID = "9e125d96227fd516e34636ecf192b7f6"
    let redirectURI = "myanimeapp://auth" // same value from mal redirect uri
    
    func generateAccessToken(from url: URL, codeVerifier: String) async {
        // Capture the redirection and extract the authorization code
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let authorizationCode = components.queryItems?.first(where: { $0.name == "code" })?.value
        else {
            return
        }

        let tokenRequest = AccessTokenAPIRequest(clientID: clientID, code: authorizationCode, codeVerifier: codeVerifier)
        
        do {
            let tokenResponse = try await sendRequest(tokenRequest)
            Settings.shared.accessToken = tokenResponse.accessToken
            Settings.shared.refreshToken = tokenResponse.refreshToken
            let firstTimeLogIn = Settings.shared.accessTokenLastUpdated == nil
            if firstTimeLogIn {
                // Initalize last updated to today
                Settings.shared.accessTokenLastUpdated = Date()
            }
        } catch {
            print("Erroring generating access token: \(error)")
        }
    }
    
    func buildAuthorizationURL() -> URL? {
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
    
    // Note: Access Token lasts 1 hour. Refresh Token last 31 days.
    // - Refresh token used to refresh access token which extends the user's session without them having to log in again.
    func refreshAccessToken() async {
        guard let refreshToken = Settings.shared.refreshToken else { return }

        do {
            let refreshRequest = RefreshTokenAPIRequest(clientID: clientID, refreshToken: refreshToken)
            let tokenResponse = try await sendRequest(refreshRequest)
            
            // Update tokens with new values
            Settings.shared.accessToken = tokenResponse.accessToken
            Settings.shared.refreshToken = tokenResponse.refreshToken
            Settings.shared.accessTokenLastUpdated = Date()
        } catch {
            print("Error refreshing access token: \(error)")
        }
    }
}

func createCodeVerifier() -> String {
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
