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

enum RankingSort: String, Identifiable, CaseIterable, CustomStringConvertible {
    case animeNumListUsers = "anime_num_list_users"
    case animeScore = "anime_score"
    var id: Self { self }
    
    var description: String {
        switch self {
        case .animeNumListUsers:
            return "Popularity"
        case .animeScore:
            return "Score"
        }
    }
    
    var icon: String {
        switch self {
        case .animeNumListUsers:
            return "person.2.fill"
        case .animeScore:
            return "star.fill"
        }
    }
}
