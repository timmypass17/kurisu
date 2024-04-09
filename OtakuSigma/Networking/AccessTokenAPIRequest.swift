//
//  AccessTokenAPIRequest.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/26/23.
//

import Foundation

struct AccessTokenAPIRequest: APIRequest {
    let clientID: String
    let code: String
    let codeVerifier: String
    let grantType = "authorization_code"
    let redirectURI = "myanimeapp://auth"
    
    var urlRequest: URLRequest {
        var urlComponents = URLComponents(string: "https://myanimelist.net/v1/oauth2/token")!
        urlComponents.queryItems = [
            "client_id": clientID,
            "code": code,
            "code_verifier": codeVerifier,
            "grant_type": grantType,
            "redirect_uri": redirectURI
        ].map { URLQueryItem(name: $0.key, value: $0.value) }
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        request.httpBody = urlComponents.query?.data(using: .utf8)  // works without it but says error in console
        return request
    }
    
    func decodeResponse(data: Data) throws -> TokenResponse {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let tokenResponse = try jsonDecoder.decode(TokenResponse.self, from: data)
        return tokenResponse
    }
}
