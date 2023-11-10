//
//  ArchiveViewModel.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/5/23.
//

import Foundation

@MainActor
class ArchiveViewModel: ObservableObject {
    @Published var archiveList: [ArchiveSection] = []
    
    let mediaService: MediaService
    
    init(mediaService: MediaService) {
        self.mediaService = mediaService
//        print("init")
//        Task {
//            let currentYear = Calendar.current.component(.year, from: Date())
//            var archive: [ArchiveSection] = []
//            for year in (2021...currentYear).reversed() {
//                print(year)
//
//                let winterImageURL = ArchiveItem(season: .winter, imageURL: try await mediaService.getSeasonalAnime(year: String(year), season: .winter, sort: .animeNumListUsers, limit: 1, offset: 1).first?.mainPicture.medium)
//                let springImageURL = ArchiveItem(season: .spring, imageURL: try await mediaService.getSeasonalAnime(year: String(year), season: .spring, sort: .animeNumListUsers, limit: 1, offset: 1).first?.mainPicture.medium)
//                let summerImageURL = ArchiveItem(season: .summer, imageURL: try await mediaService.getSeasonalAnime(year: String(year), season: .summer, sort: .animeNumListUsers, limit: 1, offset: 1).first?.mainPicture.medium)
//                let fallImageURL = ArchiveItem(season: .fall, imageURL: try await mediaService.getSeasonalAnime(year: String(year), season: .fall, sort: .animeNumListUsers, limit: 1, offset: 1).first?.mainPicture.medium)
//
//                let section = ArchiveSection(year: String(year), winterItem: winterImageURL, springItem: springImageURL, summerItem: summerImageURL, fallItem: fallImageURL)
//                archive.append(section)
//            }
//            archiveList = archive
//            print(archiveList)
//        }
    }
    
}

struct ArchiveSection: Identifiable {
    var year: String
    var winterItem: ArchiveItem?
    var springItem: ArchiveItem?
    var summerItem: ArchiveItem?
    var fallItem: ArchiveItem?
    
    var id: UUID { UUID() }
}

struct ArchiveItem {
    var season: Season
    var imageURL: String?
}
