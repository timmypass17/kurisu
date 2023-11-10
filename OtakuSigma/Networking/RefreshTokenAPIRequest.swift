//
//  RefreshTokenAPIRequest.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/27/23.
//

import Foundation

struct RefreshTokenAPIRequest: APIRequest {
    let clientID: String
    let grantType = "refresh_token"
    let refreshToken: String
    
    var urlRequest: URLRequest {
        var urlComponents = URLComponents(string: "https://myanimelist.net/v1/oauth2/token")!
        urlComponents.queryItems = [
            "client_id": clientID,
            "grant_type": grantType,
            "refresh_token": refreshToken
        ].map { URLQueryItem(name: $0.key, value: $0.value) }
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        request.httpBody = urlComponents.query?.data(using: .utf8)
        return request
    }
    
    func decodeResponse(data: Data) throws -> TokenResponse {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let tokenResponse = try jsonDecoder.decode(TokenResponse.self, from: data)
        return tokenResponse
    }
}
