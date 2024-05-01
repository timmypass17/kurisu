//
//  UserAPIRequest.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/28/23.
//

import Foundation

struct UserAPIRequest: APIRequest {
    
    var urlRequest: URLRequest {
        var urlComponents = URLComponents(string: "https://api.myanimelist.net/v2/users/@me")!
        urlComponents.queryItems = [
            "fields": UserInfo.fields.joined(separator: ",")
        ].map { URLQueryItem(name: $0.key, value: $0.value) }
        
        var request = URLRequest(url: urlComponents.url!)
        
        if let accessToken = Settings.shared.accessToken {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
    
    func decodeResponse(data: Data) throws -> UserInfo {
        let decoder = JSONDecoder()
        let weebItemResponse = try decoder.decode(UserInfo.self, from: data)
        return weebItemResponse
    }
}
