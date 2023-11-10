//
//  WeebItemDetailAPIRequest.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/22/23.
//

import Foundation

struct MediaDetailAPIRequest<T: Media>: APIRequest {
    var id: Int
    var fields: [String]
    
    var urlRequest: URLRequest {
        var urlComponents = URLComponents(string: "\(T.baseURL)/\(id)")!
        urlComponents.queryItems = [
            "fields": fields.joined(separator: ",") + ",my_list_status"
        ].map { URLQueryItem(name: $0.key, value: $0.value) }
        var request = URLRequest(url: urlComponents.url!)
        if let accessToken = Settings.shared.accessToken {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
//        request.setValue(apiKey, forHTTPHeaderField: "X-MAL-CLIENT-ID")
        return request
    }

    func decodeResponse(data: Data) throws -> T {
        let decoder = JSONDecoder()
        let weebItemResponse = try decoder.decode(T.self, from: data)
        return weebItemResponse
    }
}
