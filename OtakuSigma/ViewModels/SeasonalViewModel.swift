//
//  SeasonalViewModel.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/3/23.
//

import Foundation

@MainActor
class SeasonalViewModel: ObservableObject {
    @Published var animes: [Anime] = []
    @Published var selectedSeason: SeasonTab = .current {
        didSet {
            loadAnime()
        }
    }
    @Published var selectedSort: RankingSort = .animeNumListUsers {
        didSet {
            loadAnime()
        }
    }
    
    var title: String {
        switch selectedSeason {
        case .previous:
            return "\(previousSeason.rawValue.capitalized) \(previousYear)"
        case .current:
            return "\(currentSeason.rawValue.capitalized) \(currentYear)"
        case .next:
            return "\(nextSeason.rawValue.capitalized) \(nextYear)"
        }
    }
    
    var season: Season {
        switch selectedSeason {
        case .previous:
            return previousSeason
        case .current:
            return currentSeason
        case .next:
            return nextSeason
        }
    }
    var year: Int {
        switch selectedSeason {
        case .previous:
            return previousYear
        case .current:
            return currentYear
        case .next:
            return nextYear
        }
    }
    
    let previousSeason: Season
    let currentSeason: Season
    let nextSeason: Season
    let previousYear: Int
    let currentYear: Int
    let nextYear: Int
    
    let mediaService: MediaService
    private let limit = 10
    private var page = 0
    var offset: Int {
        return page * limit
    }
    
    init(mediaService: MediaService) {
        self.mediaService = mediaService
        
        let seasons: [Season] = Season.allCases
        currentYear = Calendar.current.component(.year, from: .now)
        let month = Calendar.current.component(.month, from: .now)
        switch month {
        case 1...3:
            currentSeason = .winter
        case 4...6:
            currentSeason = .spring
        case 7...9:
            currentSeason = .summer
        default:
            currentSeason = .fall
        }

        let index = seasons.firstIndex(of: currentSeason)!
        previousSeason = seasons[(index - 1) % 4]
        nextSeason = seasons[(index + 1) % 4]
        previousYear = currentSeason != .winter ? currentYear : currentYear - 1
        nextYear = currentSeason != .fall ? currentYear : currentYear + 1
        
        loadAnime()
    }
    
    func loadAnime() {
        Task {
            page = 0
            animes = try await mediaService.getSeasonalAnime(year: String(year), season: season, sort: selectedSort, limit: limit, offset: offset)
            page += 1
        }
    }
    
    func loadMoreAnime() {
        Task {
            animes.append(contentsOf: try await mediaService.getSeasonalAnime(year: String(year), season: season, sort: selectedSort, limit: limit, offset: offset))
            page += 1
        }
    }
}

enum Season: String, CaseIterable {
    case winter, spring, summer, fall
}

enum SeasonYear {
    case winter(String)
    case spring(String)
    case summer(String)
    case fall(String)
    
    var description: String {
        switch self {
        case .winter(let year):
            return "Winter \(year)"
        case .spring(let year):
            return "Spring \(year)"
        case .summer(let year):
            return "Summer \(year)"
        case .fall(let year):
            return "Fall \(year)"
        }
    }
}

enum SeasonTab: String, Identifiable, CaseIterable {
    case previous
    case current
    case next
    
    var id: Self { self }
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
