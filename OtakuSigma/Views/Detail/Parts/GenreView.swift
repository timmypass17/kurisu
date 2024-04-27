//
//  GenreView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/24/23.
//

import SwiftUI

struct GenreView: View {
    let item: Media
    var maxTags = Int.max
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                ForEach(item.genres.prefix(maxTags), id: \.name) { tag in
                    TagView(text: tag.name)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct TagView: View {
    var text: String
    var image: Image? = nil
    
    var body: some View {
        HStack {
            image
            
            Text(text)
        }
        .borderedTag()
    }
}

struct GenreView_Previews: PreviewProvider {
    static var previews: some View {
        GenreView(item: sampleAnimes[0])
    }
}
