//
//  ArchiveCellView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/5/23.
//

import SwiftUI

struct ArchiveCellView: View {
    let item: ArchiveItem?

    var body: some View {
        if let item = item, let imageURL = item.imageURL {
            AsyncImage(url: URL(string: imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(2/3, contentMode: .fit)
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .overlay(Color.black.opacity(0.24))
            .overlay {
                Text(item.season.rawValue.capitalized)
                    .bold()
                    .foregroundColor(.white)
            }
            .clipShape(RoundedRectangle(cornerRadius: 5))

        } else {
            RoundedRectangle(cornerRadius: 5)
                .fill(.blue)
        }
    }
}

struct ArchiveCellView_Previews: PreviewProvider {
    static var previews: some View {
//        ArchiveCellView(item: sampleArchiveItem, width: 100, height: 150)
        ArchiveCellView(item: sampleArchiveItem)


    }
}

let sampleArchiveItem = ArchiveItem(season: .winter, imageURL: sampleAnimes[0].mainPicture.medium)
