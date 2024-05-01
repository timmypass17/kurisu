//
//  GenreRow.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 4/30/24.
//

import SwiftUI

struct GenreRow: View {
    let genres: [Genre]
    var tagCount = Int.max
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                ForEach(genres.prefix(tagCount), id: \.name) { tag in
                    TagView(text: tag.name)
                }
                
                if genres.count > tagCount {
                    HStack(spacing: 0) {
                        Image(systemName: "plus")
                        Text("\((genres.count) - tagCount) more")
                    }
                    .foregroundColor(.secondary)
                    .padding(.leading, 2)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
