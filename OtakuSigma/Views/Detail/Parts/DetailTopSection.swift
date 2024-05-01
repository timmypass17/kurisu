//
//  DetailTopSection.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/9/23.
//

import SwiftUI

struct DetailTopSection<T: Media>: View {
    @State var isTitleExpanded = false
    @State var isJapaneseTitleExpanded = false
    let media: T
    
    var mediaIcon: String {
        if media is Anime {
            return "tv"
        }
        return "book"
    }
    
    var secondaryIcon: String {
        if media is Anime {
            return "clock"
        }
        return "books.vertical"
    }
    
    var body: some View {
        HStack(alignment: .top) {
            PosterView(imageURL: media.mainPicture.large, width: 120, height: 200)
            
            
            VStack(alignment: .leading, spacing: 0) {
                Text(media.startSeasonString)
                    .foregroundStyle(.secondary)
                    .shadow(radius: 1, x: 1, y: 2)

                Text(media.getTitle())
                    .font(.system(size: 24))
                    .lineLimit(isTitleExpanded ? nil : 2)
                    .shadow(radius: 5, x: 1, y: 2)

                Text(media.title) // jsp title
                    .lineLimit(1)
                    .foregroundStyle(.secondary)
                    .shadow(radius: 1, x: 1, y: 2)
                
                HStack {
                    Label("\(media.numEpisodesOrChapters) \(media.getEpisodeOrChapterString().capitalized)s", systemImage: mediaIcon)
                        .font(.system(size: 12))
                    
                    Circle()
                        .frame(width: 3)
                    
                    Label("\(media.minutesOrVolumes) \(media.getMinutesOrVolumesString())", systemImage: secondaryIcon)
                        .font(.system(size: 12))
                }
                .padding(.top, 8)
                
                HStack {
                    ScoreCellView(title: "Score", description: media.scoreString)
                    
                    if let rank = media.rank {
                        ScoreCellView(title: "Rank", description: "\(rank)", systemImage: "number")
                    } else {
                        ScoreCellView(title: "Rank", description: "?")
                    }
                    
                    ScoreCellView(title: "Popularity", description: formatNumber(media.numListUsers), systemImage: "person.2")
                }
                .padding(.top)
            }
            
            Spacer()
        }
    }
}

struct DetailTopSection_Previews: PreviewProvider {
    static var previews: some View {
        DetailTopSection(media: sampleAnimes[0])
    }
}

extension Double {
    func reduceScale(to places: Int) -> Double {
        let multiplier = pow(10, Double(places))
        let newDecimal = multiplier * self // move the decimal right
        let truncated = Double(Int(newDecimal)) // drop the fraction
        let originalDecimal = truncated / multiplier // move the decimal back
        return originalDecimal
    }
}

func formatNumber(_ n: Int) -> String {
    let num = abs(Double(n))
    let sign = (n < 0) ? "-" : ""
    
    switch num {
    case 1_000_000_000...:
        var formatted = num / 1_000_000_000
        formatted = formatted.reduceScale(to: 1)
        return "\(sign)\(formatted)B"
        
    case 1_000_000...:
        var formatted = num / 1_000_000
        formatted = formatted.reduceScale(to: 1)
        return "\(sign)\(formatted)M"
        
    case 1_000...:
        var formatted = num / 1_000
        formatted = formatted.reduceScale(to: 1)
        return "\(sign)\(formatted)K"
        
    case 0...:
        return "\(n)"
        
    default:
        return "\(sign)\(n)"
    }
}
