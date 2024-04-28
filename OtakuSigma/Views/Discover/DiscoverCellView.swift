//
//  DiscoverCellView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/1/23.
//

import SwiftUI

struct DiscoverCellView<T: Media>: View {
    let media: T
    var width: CGFloat = 100
    var height: CGFloat = 150

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            PosterView(imageURL: media.mainPicture.large, width: width, height: height, includeBorder: false)
//            AsyncImage(url: URL(string: media.mainPicture.large)) { image in
//                image
//                    .resizable()
//                    .scaledToFill()
//            } placeholder: {
//                Color(uiColor: UIColor.tertiarySystemFill)
//            }
//            .frame(width: width, height: height)
//            .clipShape(RoundedRectangle(cornerRadius: 5))
            
            Text(media.getTitle())
                .font(.system(size: 14))
                .lineLimit(1)
                .padding(.top, 4)
            
            let numEpisodesOrChaptersString = media.numEpisodesOrChapters > 0 ? "\(media.numEpisodesOrChapters)" : "?"
            Text("\(media.mediaType.uppercased()) - \(numEpisodesOrChaptersString) \(media.getEpisodeOrChapterString().capitalized)s")
                .lineLimit(1)
                .foregroundColor(.secondary)
                .font(.system(size: 10))

            AiringView(status: media.status)
                .padding(.top, 2)
                        
        }
        .frame(width: width)
//        .contentShape(RoundedRectangle(cornerRadius: 5)) // fixes overlap click area
    }
}


struct DiscoverCellView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            DiscoverCellView(media: sampleAnimes[0])
        }
    }
}
