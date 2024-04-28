//
//  MediaStatus.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 4/9/24.
//

import Foundation
import SwiftUI

protocol MediaStatus: Codable {
    var description: String { get }
    var color: Color { get }
    var systemImage: String { get }
//    var 
}

enum AnimeStatus: String, MediaStatus {
    case currentlyAiring = "currently_airing"
    case notYetAired = "not_yet_aired"
    case finishedAiring = "finished_airing"
    
    var description: String {
        return self.rawValue.capitalized.replacingOccurrences(of: "_", with: " ")
    }
    
    var color: Color {
        switch self {
        case .currentlyAiring:
            return .yellow
        case .notYetAired:
            return .pink
        case .finishedAiring:
            return .green
        }
    }
    
    var systemImage: String {
        switch self {
        case .currentlyAiring:
            return "clock"
        case .notYetAired:
            return "clock"
        case .finishedAiring:
            return "sparkles"
        }
    }
}

enum MangaStatus: String, MediaStatus {
    case currentlyPublishing = "currently_publishing"
    case finished = "finished"
    case onHiatus = "on_hiatus"
    
    var description: String {
        return self.rawValue.capitalized.replacingOccurrences(of: "_", with: " ")
    }
    
    var color: Color {
        switch self {
        case .currentlyPublishing:
            return .yellow
        case .finished:
            return .green
        case .onHiatus:
            return .pink
        }
    }
    
    var systemImage: String {
        switch self {
        case .currentlyPublishing:
            return "clock"
        case .finished:
            return "sparkles"
        case .onHiatus:
            return "clock"
        }
    }
}
