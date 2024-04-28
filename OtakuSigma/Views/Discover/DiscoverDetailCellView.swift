//
//  DiscoverDetailCellView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/6/23.
//

import SwiftUI


struct DiscoverDetailCellView: View {
    let item: Media
    var width: CGFloat
    var height: CGFloat {
        ((85 * width) / 135) * 2.5
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            PosterView(imageURL: item.mainPicture.large, width: width, height: height, includeBorder: false)

            Text(item.getTitle())
                .font(.system(size: 14))
                .lineLimit(1)
                .padding(.top, 4)

            let numEpisodesOrChaptersString = item.numEpisodesOrChapters > 0 ? "\(item.numEpisodesOrChapters)" : "?"
            Text("\(item.mediaType.uppercased()) - \(numEpisodesOrChaptersString) \(item.getEpisodeOrChapterString().capitalized)s")
                .foregroundColor(.secondary)
                .font(.system(size: 10))
            
            AiringView(status: item.status)
                .padding(.top, 2)
        }
    }
}

//struct DiscoverDetailCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        DiscoverDetailCellView(item: sampleAnimes[0])
//    }
//}
