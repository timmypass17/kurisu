//
//  ArchiveView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/5/23.
//

import SwiftUI

struct ArchiveView: View {
    @StateObject var archiveViewModel = ArchiveViewModel(mediaService: MALService())
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(archiveViewModel.archiveList, id: \.id) { section in
//                    ArchiveCellView(item: section.fallItem, width: 100, height: 100)
                    ArchiveRowView(archiveSection: section)
                }
            }
            .navigationTitle("All Seasons")
        }
    }
}

struct ArchiveView_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveView()
    }
}
