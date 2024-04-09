//
//  UserStatAPIRequest.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/30/23.
//

import Foundation

struct UserAddtionalAPIRequest<T: GenreItemProtocol>: APIRequest {
    var sort = "list_updated_at"
    var baseURL: String {
        if T.self == AnimeGenreItem.self {
            return "https://api.myanimelist.net/v2/users/@me/animelist"
        } else {
            return "https://api.myanimelist.net/v2/users/@me/mangalist"
        }
    }
    
    var fields: [String] = ["genres", "list_status"]
    
    var urlRequest: URLRequest {
        var urlComponents = URLComponents(string: baseURL)!
        urlComponents.queryItems = [
            "sort": sort,
            "fields": fields.joined(separator: ","),
            "limit": "100"
        ].map { URLQueryItem(name: $0.key, value: $0.value) }
        var request = URLRequest(url: urlComponents.url!)
        if let accessToken = Settings.shared.accessToken {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
    
    func decodeResponse(data: Data) throws -> [T] {
        let decoder = JSONDecoder()
        let response = try decoder.decode(UserGenreResponse<T>.self, from: data)
        return response.data
    }
}
