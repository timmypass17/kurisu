//
//  GenreRowView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/9/23.
//

import SwiftUI

struct GenreRowView: View {
    let genres: [String]
    var maxTags = Int.max
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                ForEach(genres.prefix(maxTags), id: \.self) { genre in
                    TagView(text: genre)
                }
                
                if genres.count > maxTags {
                    HStack(spacing: 0) {
                        Image(systemName: "plus")
                        Text("\(genres.count - maxTags) more")
                    }
                    .foregroundColor(.secondary)
                    .padding(.leading, 2)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct GenreRowView_Previews: PreviewProvider {
    static var previews: some View {
        GenreRowView(genres: sampleAnimes[0].genres.map { $0.name })
    }
}
