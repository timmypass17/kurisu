//
//  Anime.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/25/23.
//

import Foundation

struct Anime: Media {
    var id: Int
    var title: String
    var alternativeTitles: AlternativeTitles
    var numEpisodesOrChapters: Int { numEpisodes }
    var numEpisodes: Int
    var mainPicture: MainPicture
    var genres: [Genre]
    var status: MediaStatus {
        get { animeStatus }
    }
    var animeStatus: AnimeStatus
    
    var startSeason: StartSeason?
    var broadcast: Broadcast?
    var startDate: String?
    var endDate: String?
    var synopsis: String
    var myAnimeListStatus: AnimeListStatus?
    
    var myListStatus: ListStatus? {
        get { return myAnimeListStatus }
        set {
            myAnimeListStatus = newValue as? AnimeListStatus
        }
    }
    var averageEpisodeDuration: Int
    var minutesOrVolumes: Int { averageEpisodeDuration / 60 }
    var mean: Float?
    var rank: Int?
    var popularity: Int
    var numListUsers: Int
    var relatedAnime: [RelatedItem]   // relatedAnime key may not exist so its nil.
    var relatedManga: [RelatedItem]
    var mediaType: String
    var studios: [Studio]
    var source: String
    var recommendations: [RecommendedItem]
    var rating: String?
    var statistics: Statistics
    
    var broadcastString: String {
        guard let startDate, let startTime = broadcast?.startTime else { return "?" }
        
        let combinedDateString = "\(startDate) \(startTime)"
        
        // Parse the combined date and time string
        let combinedDateFormatter = DateFormatter()
        combinedDateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        combinedDateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        
        if let combinedDate = combinedDateFormatter.date(from: combinedDateString) {
            // Convert to the user's local time zone
            let userTimeZone = TimeZone.current
            let userDateFormatter = DateFormatter()
            userDateFormatter.dateFormat = "EEEE 'at' h:mma (zzz)"
            userDateFormatter.timeZone = userTimeZone
            
            let userDateString = userDateFormatter.string(from: combinedDate)
            return userDateString
        } else {
            return "?"
        }
    }
    
    mutating func updateListStatus(status: String, score: Int, progress: Int, comments: String?) {
        myAnimeListStatus = AnimeListStatus(status: status, score: score, numEpisodesWatched: progress, comments: comments)
    }
    
    func episodeOrChapterString() -> String {
        return "Episodes"
    }
    
    var nextReleaseString: String {
        switch animeStatus {
        case .currentlyAiring:
            guard let weekday = broadcast?.dayOfTheWeek,
                  let startTime = broadcast?.startTime,
                  let nextEpisodeDate = getNextEpisodeDate(weekday: weekday, militaryTime: startTime)
            else { return "No next" }
            
            return nextEpisodeDate.formatted(date: .abbreviated, time: .shortened)
        case .notYetAired:
            guard let startDateString = startDate else { return "TBA" }
            print(title, startDateString)

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd" // ex. 2024-05-12
            
            let otherDateFormatter = DateFormatter()
            otherDateFormatter.dateFormat = "yyyy-MM" // ex. 2024-10
            
            if var jspDate = dateFormatter.date(from: startDateString) {
                return jspDate.formatted(date: .abbreviated, time: .omitted)
            } else if var jspDate = otherDateFormatter.date(from: startDateString) {
                let dateParts = Calendar.current.dateComponents([.year, .month], from: jspDate)
                return "\(otherDateFormatter.monthSymbols[dateParts.month! - 1]) \(dateParts.year!)"
            }
            
            return "Failed to convert JSP to PST"
        case .finishedAiring:
            return "Finished Airing"
        }
    }
    
}

struct Statistics: Codable {
    var status: Status
    var numListUsers: Int
    
    enum CodingKeys: String, CodingKey {
        case status
        case numListUsers = "num_list_users"
    }
    
    func toChartData() -> [BarChartItem] {
        let watching = BarChartItem(value: Double(status.watching) ?? 0.0, category: "Watching")
        let completed = BarChartItem(value: Double(status.completed) ?? 0.0, category: "Completed")
        let onHold = BarChartItem(value: Double(status.onHold) ?? 0.0, category: "On Hold")
        let planToWatch = BarChartItem(value: Double(status.planToWatch) ?? 0.0, category: "Plan To Watch")
        let dropped = BarChartItem(value: Double(status.dropped) ?? 0.0, category: "Dropped")
        
        return [watching, completed, onHold, planToWatch, dropped]
    }
}

struct Status: Codable {
    var watching: String
    var completed: String
    var onHold: String
    var dropped: String
    var planToWatch: String
    
    enum CodingKeys: String, CodingKey {
        case watching
        case completed
        case onHold = "on_hold"
        case dropped
        case planToWatch = "plan_to_watch"
    }
    
}

struct Studio: Codable {
    var name: String
}

extension Anime: Decodable {
    static var baseURL: String { "https://api.myanimelist.net/v2/anime" }
    static var userBaseURL: String { "https://api.myanimelist.net/v2/users/@me/animelist" }
    static var numEpisodesOrChaptersKey: String { CodingKeys.numEpisodes.rawValue }
    static var fields: [String] { CodingKeys.allCases.map { $0.rawValue } }
    static var episodesOrChaptersString: String { "Episodes" }
    static var episodeOrChapterString: String { "Episode" }
    static var minutesOrVolumesString: String { "Minutes" }
    static var relatedItemString: String { "Related Animes" }
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case title
        case alternativeTitles = "alternative_titles"
        case numEpisodes = "num_episodes"
        case mainPicture = "main_picture"
        case genres
        case animeStatus = "status"
        case startSeason = "start_season"
        case broadcast
        case startDate = "start_date"
        case endDate = "end_date"
        case synopsis
        case myAnimeListStatus = "my_list_status"
        case averageEpisodeDuration = "average_episode_duration"
        case mean
        case rank
        case popularity
        case numListUsers = "num_list_users"
        case relatedAnime = "related_anime"
        case relatedManga = "related_manga"
        case mediaType = "media_type"
        case studios
        case source
        case recommendations
        case rating
        case statistics
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        alternativeTitles = try values.decode(AlternativeTitles.self, forKey: .alternativeTitles)
        numEpisodes = try values.decode(Int.self, forKey: .numEpisodes)
        mainPicture = try values.decode(MainPicture.self, forKey: .mainPicture)
        genres = try values.decodeIfPresent([Genre].self, forKey: .genres) ?? []
        animeStatus = try values.decode(AnimeStatus.self, forKey: .animeStatus)
        startSeason = try values.decodeIfPresent(StartSeason.self, forKey: .startSeason)
        broadcast = try values.decodeIfPresent(Broadcast.self, forKey: .broadcast)
        startDate = try values.decodeIfPresent(String.self, forKey: .startDate)
        endDate = try values.decodeIfPresent(String.self, forKey: .endDate)
        synopsis = try values.decode(String.self, forKey: .synopsis)
        myAnimeListStatus = try values.decodeIfPresent(AnimeListStatus.self, forKey: .myAnimeListStatus)
        averageEpisodeDuration = try values.decode(Int.self, forKey: .averageEpisodeDuration)
        mean = try values.decodeIfPresent(Float.self, forKey: .mean)
        rank = try values.decodeIfPresent(Int.self, forKey: .rank)
        popularity = try values.decode(Int.self, forKey: .popularity)
        numListUsers = try values.decode(Int.self, forKey: .numListUsers)
        relatedAnime = try values.decodeIfPresent([RelatedItem].self, forKey: .relatedAnime) ?? []
        relatedManga = try values.decodeIfPresent([RelatedItem].self, forKey: .relatedManga) ?? []
        mediaType = try values.decode(String.self, forKey: .mediaType)
        studios = try values.decode([Studio].self, forKey: .studios)
        source = try values.decodeIfPresent(String.self, forKey: .source) ?? "?"
        recommendations = try values.decodeIfPresent([RecommendedItem].self, forKey: .recommendations) ?? []
        rating = (try values.decodeIfPresent(String.self, forKey: .rating) ?? "?").uppercased().replacingOccurrences(of: "_", with: " ")
        statistics = (try values.decodeIfPresent(Statistics.self, forKey: .statistics)) ?? Statistics(status: Status(watching: "0", completed: "0", onHold: "0", dropped: "0", planToWatch: "0"), numListUsers: 0)
    }
}

func getNextEpisodeDate(weekday: String, militaryTime: String) -> Date? {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd HH:mm"
    formatter.timeZone = TimeZone.current
    
    // Get the current date and time in JSP timezone
    var dateComponents = DateComponents()
    dateComponents.weekday = getWeekdayNumber(weekday: weekday)
    let militaryTimeComponents = militaryTime.split(separator: ":")
    if militaryTimeComponents.count == 2,
       let hour = Int(militaryTimeComponents[0]),
       let minute = Int(militaryTimeComponents[1]) {
        dateComponents.hour = hour
        dateComponents.minute = minute
    } else {
        return nil
    }
    
    let jspDate = Calendar.current.nextDate(after: Date(), matching: dateComponents, matchingPolicy: .nextTime, direction: .forward)!
    
    // Convert JSP time to PST
    let pstDate = jspDate.convertToTimeZone(initTimeZone: TimeZone(identifier: "JST")!, timeZone: TimeZone.current)
    
    return pstDate
}

func getWeekdayNumber(weekday: String) -> Int {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "EEEE"
    guard let date = formatter.date(from: weekday) else {
        return 1 // Default to Monday if unable to parse
    }
    let calendar = Calendar.current
    return calendar.component(.weekday, from: date)
}

//// Example usage
//if let convertedTime = convertTimeToCurrentUserTimeZone(weekday: "tuesday", militaryTime: "13:30") {
//    print(convertedTime.formatted(date: .abbreviated, time: .shortened))
//} else {
//    print("Unable to convert the time.")
//}

extension Date {
    func convertToTimeZone(initTimeZone: TimeZone, timeZone: TimeZone) -> Date {
        let delta = TimeInterval(timeZone.secondsFromGMT(for: self) - initTimeZone.secondsFromGMT(for: self))
        return addingTimeInterval(delta)
    }
}
