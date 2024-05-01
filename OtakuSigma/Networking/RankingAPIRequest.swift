//
//  RankingAPIRequest.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/1/23.
//

import Foundation

struct RankingAPIRequest<T: Media>: APIRequest {
    var rankingType: String
    var fields: [String]
    var limit: Int
    var offset: Int
    
    var urlRequest: URLRequest {
        var urlComponents = URLComponents(string: "\(T.baseURL)/ranking")!
        urlComponents.queryItems = [
            "ranking_type": rankingType,
            "fields": fields.joined(separator: ","),
            "limit": "\(limit)",
            "offset": "\(offset)"
        ].map { URLQueryItem(name: $0.key, value: $0.value) }
        var request = URLRequest(url: urlComponents.url!)
        if let accessToken = Settings.shared.accessToken {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } 
        return request
    }

    func decodeResponse(data: Data) throws -> [T] {
        let decoder = JSONDecoder()
        let weebItemResponse = try decoder.decode(MediaListResponse<T>.self, from: data)
        return weebItemResponse.data.map { $0.node }
    }
}
