//
//  MediaStatsView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/16/23.
//

import SwiftUI

struct InfoView<T: Media>: View {
    let media: T
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Information".uppercased())
            if let anime = media as? Anime {
                StatsCell(title: "Alternate Title", image: "t.square", value: anime.alternativeTitles.en)
                StatsCell(title: "Type", image: "magnifyingglass", value: anime.mediaType.uppercased())
                StatsCell(title: "\(media.getEpisodeOrChapterString().capitalized)s", image: "tv", value: anime.numEpisodesOrChapters)
                StatsCell(title: "Status", image: "leaf", value: media.status.description)
                StatsCell(title: "Aired", image: "calendar", value: anime.airedString)
                StatsCell(title: "Premiered", image: "calendar", value: media.startSeasonString)
                StatsCell(title: "Broadcast", image: "record.circle", value: anime.broadcastString)
                StatsCell(title: "Studios", image: "building", value: anime.studios.map { $0.name }.joined(separator: ", "))
                StatsCell(title: "Source", image: "leaf", value: anime.source.capitalized)
                StatsCell(title: "Genres", image: "book.closed", value: media.genres.map { $0.name }.joined(separator: ", "))
                // theme
                // demographic
                StatsCell(title: "Duration", image: "clock", value: "\(anime.minutesOrVolumes) min. per epi.")
                StatsCell(title: "Rating", image: "star.fill", value: anime.rating ?? "-")
            } else if let manga = media as? Manga {
                StatsCell(title: "Type", image: "magnifyingglass", value: manga.mediaType.uppercased())
                StatsCell(title: "Volumes", image: "books.vertical", value: manga.minutesOrVolumes)
                StatsCell(title: "Chapters", image: "book", value: manga.numEpisodesOrChapters)
                StatsCell(title: "Status", image: "leaf", value: media.status.description)
                StatsCell(title: "Published", image: "calendar", value: manga.airedString)
                StatsCell(title: "Genres", image: "book.closed", value: manga.genres.map { $0.name }.joined(separator: ", "))
                // theme
                // demographic
                // *serialization
                StatsCell(title: "Authors", image: "person.fill", value: manga.authors.map { "\($0.node.lastName), \($0.node.firstName) (\($0.role))" }.joined(separator: "\n"))
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 4)
                .fill(.regularMaterial)
        }
    }
}

struct StatsCell<T: CustomStringConvertible>: View {
    let title: String
    let image: String
    let value: T
    
    @State var isExpanded = false
    var body: some View {
        VStack {
            Divider()
            
            HStack(alignment: .top) {
                Label(title, systemImage: image)
                    .padding(.trailing)
                
                Spacer()
                
                Text("\(value.description)")
                    .lineLimit(isExpanded ? nil : 1)
                    .foregroundStyle(.secondary)
            }
            .onTapGesture {
                isExpanded.toggle()
            }
        }
    }
}

#Preview {
    InfoView<Anime>(media: sampleAnimes[0])
}
