//
//  MediaSort.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 4/9/24.
//

import Foundation

protocol MediaSort {
    var key: String { get }
}

enum AnimeSort: String, MediaSort {
    case listScore = "list_score"
    case listUpdatedAt = "list_updated_at"
    case animeTitle = "anime_title"
    case animeStartDate = "anime_start_date"
    
    var key: String {
        return self.rawValue
    }
}

enum MangaSort: String, MediaSort {
    case listScore = "list_score"
    case listUpdatedAt = "list_updated_at"
    case mangaTitle = "manga_title"
    case mangaStartDate = "manga_start_date"
    
    var key: String {
        return self.rawValue
    }
}
