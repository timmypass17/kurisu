//
//  UserAnimeListAPIRequest.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/26/23.
//

import Foundation


struct UserListAPIRequest<T: Media>: APIRequest {
    // TODO: Move Status and Sort into Media (like fields ex. T.fields)
    var status: String
    var sort: String
    var fields: [String]
    var limit: Int = 100
    // limit, offset (may need to add for pagination)
    
    var urlRequest: URLRequest {
        var urlComponents = URLComponents(string: T.userBaseURL)!
        urlComponents.queryItems = [
            "status": status,
            "sort": sort ,
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


protocol MediaStatus: CaseIterable, Identifiable, Hashable {
    var rawValue: String { get }
}

enum AnimeStatus: String, MediaStatus {
    case watching
    case completed
    case onHold = "on_hold"
    case dropped
    case planToWatch = "plan_to_watch"
    
    var id: Self { self }
}

enum MangaStatus: String, MediaStatus {
    case reading
    case completed
    case onHold = "on_hold"
    case dropped
    case planToRead = "plan_to_read"
    
    var id: Self { self }}

protocol Sort {
    var description: String { get }
}

enum AnimeSort: String, Sort {
    case listScore = "list_score"
    case listUpdatedAt = "list_updated_at"
    case animeTitle = "anime_title"
    case animeStartDate = "anime_start_date"
    
    var description: String {
        return self.rawValue
    }
}

enum MangaSort: String, Sort {
    case listScore = "list_score"
    case listUpdatedAt = "list_updated_at"
    case mangaTitle = "manga_title"
    case mangaStartDate = "manga_start_date"
    
    var description: String {
        return self.rawValue
    }
}
