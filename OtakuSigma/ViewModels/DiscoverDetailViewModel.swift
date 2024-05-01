//
//  DiscoverDetailViewModel.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/6/23.
//

import Foundation

@MainActor
class DiscoverDetailViewModel<T: Media>: ObservableObject {
    @Published var items: [T] = []
    @Published var isLoading = false
    let ranking: Ranking?
    let year: Int?
    let season: Season?

    let mediaService: MediaService
    private let limit = 100
    private var page = 0
    
    var mediaTask: Task<Void, Never>? = nil
    var listViewMediaLoadTasks: [IndexPath: Task<Void, Never>] = [:]
    
    init(mediaService: MediaService, ranking: Ranking? = nil, year: Int? = nil, season: Season? = nil) {
        self.mediaService = mediaService
        self.ranking = ranking
        self.year = year
        self.season = season
    }
    
    func loadMedia() {
        // cancel any media that are still being fetched and reset the mediaTasks dictionaries
        listViewMediaLoadTasks.values.forEach { task in task.cancel() }
        listViewMediaLoadTasks = [:]
        
        // cancel existing task since we will not use the result
        mediaTask?.cancel()
        mediaTask = Task {
            print("loadMedia (page: \(page))")
            do {
                isLoading = true
                if let ranking = ranking {
                    items.append(contentsOf: try await mediaService.getMediaRanking(rankingType: ranking.type, limit: limit, offset: page * limit))
                } else if let year = year, let season = season {
                    items.append(contentsOf: try await mediaService.getSeasonalAnime(year: String(year), season: season, sort: .animeNumListUsers, limit: limit, offset: page * limit))
                }
                page += 1
                isLoading = false
            } catch {
                print("Error loading media: \(error)")
                isLoading = false
            }
        }
    }
}

enum Season: String, CaseIterable {
    case winter, spring, summer, fall
}
