//
//  UserAnimeListAPIRequest.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/26/23.
//

import Foundation


struct UserListAPIRequest<T: Media>: APIRequest {
    // TODO: Move Status and Sort into Media (like fields ex. T.fields)
    var status: any MediaStatus
    var sort: any MediaSort
    var fields: [String]
    var limit: Int = 100
    // limit, offset (may need to add for pagination)
    
    var urlRequest: URLRequest {
        var urlComponents = URLComponents(string: T.userBaseURL)!
        urlComponents.queryItems = [
            "status": status.key,
            "sort": sort.key,
            "fields": fields.joined(separator: ",")
//            "fields": T.fields.joined(separator: ",") + ",list_status"
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
