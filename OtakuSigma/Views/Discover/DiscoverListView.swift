//
//  DiscoverListView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/1/23.
//

import SwiftUI

struct DiscoverListView<T: Media>: View {
    var sections: [MediaSection<T>]
    
    var body: some View {
        VStack {
            ForEach(sections) { section in
                DiscoverRowView(ranking: section.ranking, items: section.items)
            }
        }
    }
}
