//
//  WeebListAPIRequest.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/22/23.
//

import Foundation

// note: can't get user's list status
struct WeebListAPIRequest<T: Media>: APIRequest {
    var title: String
    var fields: [String]
    
    var urlRequest: URLRequest {
        var urlComponents = URLComponents(string: "\(T.baseURL)")!
        urlComponents.queryItems = [
            "q": title,
            "fields": fields.joined(separator: ",")
        ].map { URLQueryItem(name: $0.key, value: $0.value) }
        var request = URLRequest(url: urlComponents.url!)
        if let accessToken = Settings.shared.accessToken {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else {
            request.setValue(apiKey, forHTTPHeaderField: "X-MAL-CLIENT-ID")
        }
        return request
    }

    func decodeResponse(data: Data) throws -> [T] {
        let decoder = JSONDecoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase   // breaks something
        let weebItemResponse = try decoder.decode(MediaListResponse<T>.self, from: data)
        return weebItemResponse.data.map { $0.node }
    }
}
