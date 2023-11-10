//
//  SeasonalAnimeAPIRequest.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/3/23.
//

import Foundation

struct SeasonalAnimeAPIRequest<T: Media>: APIRequest {
    var year: String
    var season: Season
    var sort: RankingSort
    var limit: Int
    var offset: Int
    
    var urlRequest: URLRequest {
        var urlComponents = URLComponents(string: "\(Anime.baseURL)/season/\(year)/\(season)")!
        urlComponents.queryItems = [
            "fields": Anime.fields.joined(separator: ","),
            "sort": sort.rawValue,
            "limit": "\(limit)",
            "offset": "\(offset)"
        ].map { URLQueryItem(name: $0.key, value: $0.value) }
        var request = URLRequest(url: urlComponents.url!)
        request.setValue(apiKey, forHTTPHeaderField: "X-MAL-CLIENT-ID")
        return request
    }

    func decodeResponse(data: Data) throws -> [T] {
        let decoder = JSONDecoder()
        let weebItemResponse = try decoder.decode(MediaListResponse<T>.self, from: data)
        return weebItemResponse.data.map { $0.node }
    }
}
