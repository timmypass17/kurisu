//
//  RelatedCellView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/16/23.
//

import SwiftUI

struct RelatedCellView: View {
    let relatedItem: RelatedItem
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: relatedItem.node.mainPicture.medium)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            } placeholder: {
                ProgressView()
                    .frame(width: 100, height: 150)
            }
            
            Text(relatedItem.relationTypeFormatted.uppercased())
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
            
            Text(relatedItem.node.title)
                .lineLimit(2)
        }
        .frame(width: 100)
        .contentShape(RoundedRectangle(cornerRadius: 5)) // fixes overlap click area
    }
}

#Preview("RelatedCellView") {
    RelatedCellView(relatedItem: RelatedItem(node: RelatedNode(id: 0, title: "Chainsaw Man", mainPicture: sampleAnimes[0].mainPicture), relationTypeFormatted: "Sequel"))
}
