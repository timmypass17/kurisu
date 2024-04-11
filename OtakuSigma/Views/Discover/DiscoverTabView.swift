//
//  DiscoverTabView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/22/23.
//

import SwiftUI

struct DiscoverTabView: View {
    @EnvironmentObject var discoverViewModel: DiscoverViewModel

    var body: some View {
        Picker("View Mode", selection: $discoverViewModel.selectedMediaType) {
            ForEach(MediaType.allCases) { media in
                Text(media.rawValue.capitalized)
            }
        }
        .pickerStyle(.segmented)
    }
}

//struct DiscoverTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        DiscoverTabView()
//            .environmentObject(DiscoverViewModel(mediaService: MALService()))
//    }
//}
//
