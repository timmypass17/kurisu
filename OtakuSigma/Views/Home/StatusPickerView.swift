//
//  StatusPickerView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/31/23.
//

import Foundation
import SwiftUI

struct StatusPickerView<T: MediaListStatus>: View {
    @Binding var selectedStatus: T

    var body: some View {
        
//        if selectedStatus is AnimeWatchListStatus {
            Picker("View Status", selection: $selectedStatus) {
                ForEach(Array(T.tabItems)) { status in
                    Text(status.key.capitalized.replacingOccurrences(of: "_", with: " "))
                }
            }
            .pickerStyle(.segmented)
//        } 
//        else {
//            Picker("View Status", selection: $selectedStatus) {
//                ForEach(MangaReadListStatus.allCases) { status in
//                    Text(status.key.capitalized.replacingOccurrences(of: "_", with: " "))
//                }
//            }
//            .pickerStyle(.segmented)
//        }
    }
}

struct StatusPickerView_Previews: PreviewProvider {
    static var previews: some View {
        StatusPickerView(selectedStatus: .constant(AnimeWatchListStatus.watching))
    }
}
