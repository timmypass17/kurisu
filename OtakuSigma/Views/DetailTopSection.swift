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
    
    var body: some View {
        HStack(alignment: .top) {
            PosterView(imageURL: media.mainPicture.medium, width: 120, height: 200)
            
            VStack(alignment: .leading, spacing: 0) {
                Text("*Fall 2020")
                
                Text(media.title)
                    .font(.system(size: 24))
                    .lineLimit(isTitleExpanded ? nil : 2)
                
                Text("*Japanese title")
                
                HStack {
                    Label("\(media.numEpisodesOrChapters) Episodes", systemImage: "tv")
                        .font(.system(size: 12))
                    
                    Circle()
                        .frame(width: 3)
                    
                    Label("*24 mins", systemImage: "clock")
                        .font(.system(size: 12))
                }
                .padding(.top, 8)
                
                HStack {
                    ScoreCellView(title: "Score", description: "*8.65")
                    
                    ScoreCellView(title: "Rank", description: "*65", imageString: "number")
                    
                    ScoreCellView(title: "Popularity", description: "*1.1M", imageString: "person.2")
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
