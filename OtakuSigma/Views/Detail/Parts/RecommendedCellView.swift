//
//  RecommendedCellView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/17/23.
//

import SwiftUI

struct RecommendedCellView: View {
    let recommendedItem: RecommendedItem
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: recommendedItem.node.mainPicture.medium)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            } placeholder: {
                ProgressView()
                    .frame(width: 100, height: 150)
            }
            
            Label("+\(recommendedItem.numRecommendations) Recs", systemImage: "person")
                .font(.caption)
                .foregroundStyle(.secondary)
//            Text("\(recommendedItem.numRecommendations)")
//                .font(.system(size: 12))
//                .foregroundStyle(.secondary)
            
            Text(recommendedItem.node.title)
                .lineLimit(2)
        }
        .frame(width: 100)
        .contentShape(RoundedRectangle(cornerRadius: 5)) // fixes overlap click area
    }
}

#Preview("RecommendedCellView") {
    RecommendedCellView(recommendedItem: RecommendedItem(node: RelatedNode(id: 0, title: "Chainsaw Man", mainPicture: sampleAnimes[0].mainPicture), numRecommendations: 10))
}
