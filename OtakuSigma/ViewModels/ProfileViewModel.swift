//
//  ProfileViewModel.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/25/23.
//

import Foundation
import UIKit

//
//  ProfileViewModel.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/25/23.
//

import Foundation
import UIKit


@MainActor
class ProfileViewModel: ObservableObject {
    @Published var appState: AppState   // contains user list status
    
    @Published var animeGenres: [BarChartItem] = []
    @Published var animeThemes: [BarChartItem] = []
    @Published var animeDemographics: [BarChartItem] = []
    
    @Published var mangaListStatusData: [BarChartItem] = []
    @Published var mangaGenres: [BarChartItem] = []
    @Published var mangaThemes: [BarChartItem] = []
    @Published var mangaDemographics: [BarChartItem] = []
    
    var allListStatusData: [BarChartItem] {
        switch appState.state {
        case .unregistered:
            return []
        case .loggedIn(let user):
            let categories = ["Current", "Completed", "On Hold", "Planning", "Dropped"]
            var freq = [String: Int]()
            for item in user.animeStatistics.toChartData() {
                if item.category == "Watching" {
                    freq["Current", default: 0] += Int(item.value)
                    continue
                }
                if item.category == "Plan To Watch" {
                    freq["Planning", default: 0] += Int(item.value)
                    continue
                }
                freq[item.category, default: 0] += Int(item.value)
            }
            
            for item in mangaListStatusData {
                if item.category == "Reading" {
                    freq["Current", default: 0] += Int(item.value)
                    continue
                }
                if item.category == "Plan To Read" {
                    freq["Planning", default: 0] += Int(item.value)
                    continue
                }
                freq[item.category, default: 0] += Int(item.value)
            }
            return categories.map { BarChartItem(value: Double(freq[$0, default: 0]), category: $0) }
        case .sessionExpired(_):
            return []
        }
    }
    
    var allGenresData: [BarChartItem] {
        let combinedGenres = animeGenres + mangaGenres
        
        let frequencyDict = Dictionary(grouping: combinedGenres, by: { $0.category })
            .mapValues { $0.reduce(0) { $0 + Int($1.value) } }
        
        let sortedGenres = frequencyDict
            .map { BarChartItem(value: Double($0.value), category: $0.key) }
            .sorted { $0.value > $1.value } // sort by score (desc)
            .prefix(10)
//            .sorted { $0.category < $1.category }   // sort by alphabet (a-z, 97-122, so asc)
        
        return Array(sortedGenres)
    }
    
    var allThemesData: [BarChartItem] {
        let combinedThemes = animeThemes + mangaThemes
        
        let frequencyDict = Dictionary(grouping: combinedThemes, by: { $0.category })
            .mapValues { $0.reduce(0) { $0 + Int($1.value) } }
        
        let sortedThemes = frequencyDict
            .map { BarChartItem(value: Double($0.value), category: $0.key) }
            .sorted { $0.value > $1.value } // sort by score (desc)
            .prefix(10)
//            .sorted { $0.category < $1.category }   // sort by alphabet (a-z, 97-122, so asc)
        print(Array(sortedThemes))
        return Array(sortedThemes)
    }
    
    var allDemographicData: [BarChartItem] {
        let combinedDemographics = animeDemographics + mangaDemographics
        
        let frequencyDict = Dictionary(grouping: combinedDemographics, by: { $0.category })
            .mapValues { $0.reduce(0) { $0 + Int($1.value) } }
        
        let categories = ["Shounen", "Shoujo", "Seinen", "Josei", "Kids"]
        
        return categories.map { BarChartItem(value: Double(frequencyDict[$0, default: 0]), category: $0) }
    }
    
    var authService: OAuthService!
    let mediaService: MediaService
    
    enum Genre: String {
        case action, adventure, advantGarde, awardWinning, boysLove, comedy, drama, fantasy, girlsLove, gourmet, horror, mystery, romance, sciFi, sliceOfLife, sports, supernatural, suspense
    }
    
    enum Theme: String {
        case adultCast, anthropomorphic, cgdct, childcare, combatSports, crossdressing, delinquents, detective, educational, gagHumor, gore, harem, highStakesGame, historical, idolsFemale, idolsMale, isekai, iyashikei, lovePolygon, magicalSexShift, mahouShoujo, martialArts, mecha, medical, military, music, mythology, organizedCrime, otakuCulture, parody, performingArts, pets, psychological, racing, reincarnation, reverseHarem, romanticSubtext, samurai, school, showbiz, space, strategyGame, superPower, survival, teamSports, timeTravel, vampire, videoGame, visualArts, workplace
    }
    
    enum Demographic: String, CaseIterable {
        case shounen, shoujo, seinen, josei, kids
    }
    
    init(appState: AppState, mediaService: MediaService) {
        self.appState = appState
        self.mediaService = mediaService
        
        Task {
            do {
                try await loadUserAnimeStatsData()
                
                // MANGA
                
                let additionalUserMangaListInfo: [MangaGenreItem] = try await mediaService.getAdditionalUserListInfo()
                
                let mangaCategoriesCount = additionalUserMangaListInfo.reduce(into: [String : Int]()) { category, item in
                    item.node.genres.forEach { genre in
                        category[genre.name, default: 0] += 1
                    }
                }
                
                var mangaListStatusCount: [String: Int] = Dictionary(uniqueKeysWithValues: MangaStatus.allCases.map { ($0.rawValue, 0) })
                
                let listStatusData = additionalUserMangaListInfo.map { $0.myMangaListStatus }
                for listStatus in listStatusData {
                    mangaListStatusCount[listStatus.status, default: 0] += 1
                }
                print(mangaListStatusCount)
                
                var mangaGenreCount: [String: Int] = [:]
                var mangaThemeCount: [String: Int] = [:]
                var mangaDemographicCount: [String: Int] = Dictionary(uniqueKeysWithValues: Demographic.allCases.map { ($0.rawValue.capitalized, 0) })
                
                for (category, count) in mangaCategoriesCount {
                    let categoryKey = convertToCamelCase(category)
                    if let genre = Genre(rawValue: categoryKey) {
                        mangaGenreCount[category] = count
                    } else if let theme = Theme(rawValue: categoryKey) {
                        mangaThemeCount[category] = count
                    } else if let demographic = Demographic(rawValue: categoryKey) {
                        mangaDemographicCount[category] = count
                    }
                }
                
                mangaGenreCount.forEach { mangaGenres.append(BarChartItem(value: Double($0.value), category: $0.key)) }
                mangaThemeCount.forEach { mangaThemes.append(BarChartItem(value: Double($0.value), category: $0.key)) }
                Demographic.allCases.forEach { demographic in
                    if let count = mangaDemographicCount[demographic.rawValue.capitalized] {
                        mangaDemographics.append(BarChartItem(value: Double(count), category: demographic.rawValue.capitalized))
                    }
                }
                MangaStatus.allCases.forEach { status in
                    if let count = mangaListStatusCount[status.rawValue] {
                        mangaListStatusData.append(BarChartItem(value: Double(count), category: status.rawValue.capitalized.replacingOccurrences(of: "_", with: " ")))
                    }
                }
                
                print(mangaListStatusData)
                
                mangaGenres = mangaGenres.sorted(by: { $0.value < $1.value }).suffix(10)    // get top 10 genres
                mangaGenres.sort { $0.category < $1.category }  // sort by name
                
                mangaThemes = mangaThemes.sorted(by: { $0.value < $1.value }).suffix(10)
                mangaThemes.sort { $0.category < $1.category }

                
            } catch {
                print("[ProfileViewModel] Error getting addiitonal user info\n\(error)")
            }

        }
    }
    
    func loadUserAnimeStatsData() async throws {
        let additionalUserAnimeListInfo: [AnimeGenreItem] = try await mediaService.getAdditionalUserListInfo()
        
        let categoriesCount = additionalUserAnimeListInfo.reduce(into: [String : Int]()) { category, item in
            item.node.genres.forEach { genre in
                category[genre.name, default: 0] += 1
            }
        }
        
        var genreCount: [String: Int] = [:]
        var themeCount: [String: Int] = [:]
        var demographicCount: [String: Int] = Dictionary(uniqueKeysWithValues: Demographic.allCases.map { ($0.rawValue.capitalized, 0) })
        
        // Demographic is small enough, add add cases
        
        for (category, count) in categoriesCount {
            let categoryKey = convertToCamelCase(category)
            if let genre = Genre(rawValue: categoryKey) {
                genreCount[category] = count
            } else if let theme = Theme(rawValue: categoryKey) {
                themeCount[category] = count
            } else if let demographic = Demographic(rawValue: categoryKey) {
                demographicCount[category] = count
            }
        }
        
        genreCount.forEach { animeGenres.append(BarChartItem(value: Double($0.value), category: $0.key)) }
        themeCount.forEach { animeThemes.append(BarChartItem(value: Double($0.value), category: $0.key)) }
        Demographic.allCases.forEach { demographic in
            if let count = demographicCount[demographic.rawValue.capitalized] {
                animeDemographics.append(BarChartItem(value: Double(count), category: demographic.rawValue.capitalized))
            }
            
        }
        
        animeGenres.sort { $0.value < $1.value }
        animeGenres = animeGenres.suffix(10)
        animeGenres.sort { $0.category < $1.category }
        
        animeThemes.sort { $0.value < $1.value }
        animeThemes = animeThemes.suffix(10)
        animeThemes.sort { $0.category < $1.category }

    }
    
//    func loginButtonTapped() {
//        guard let authorizationURL = authService.buildAuthorizationURL() else { return }
//        UIApplication.shared.open(authorizationURL) // open myanimelist login
//    }
    
    func convertToCamelCase(_ input: String) -> String {
        // Remove parentheses
        var stringWithoutParentheses = input.replacingOccurrences(of: "[()]-", with: "", options: .regularExpression)
        
        // Split the string into words
        let words = stringWithoutParentheses.components(separatedBy: CharacterSet.alphanumerics.inverted)
        
        // Capitalize the first letter of each word (except the first one)
        let camelCasedWords = words.enumerated().map { index, word in
            index == 0 ? word.lowercased() : word.capitalized
        }
        
        // Join the words back together
        let camelCasedString = camelCasedWords.joined()
        
        return camelCasedString
    }
}

