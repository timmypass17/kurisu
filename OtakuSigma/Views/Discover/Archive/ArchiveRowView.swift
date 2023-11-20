//
//  ArchiveRowView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/5/23.
//

import SwiftUI

struct ArchiveRowView: View {
    var archiveSection: ArchiveSection
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack {
            Text(archiveSection.year)
            
            LazyVGrid(columns: columns, spacing: 10) {
                NavigationLink {
                    
                } label: {
                    ArchiveCellView(item: archiveSection.winterItem)
                }
                ArchiveCellView(item: archiveSection.springItem)
                ArchiveCellView(item: archiveSection.summerItem)
                ArchiveCellView(item: archiveSection.fallItem)
            }
            
        }
        .padding(.horizontal)
        
    }
}

struct ArchiveRowView_Previews: PreviewProvider {
    static let sampleURL = sampleAnimes[0].mainPicture.medium
    static var previews: some View {
        ArchiveRowView(archiveSection: ArchiveSection(
            year: "2022",
            winterItem: sampleArchiveItem,
            springItem: sampleArchiveItem,
            summerItem: sampleArchiveItem,
            fallItem: sampleArchiveItem))
    }
}
