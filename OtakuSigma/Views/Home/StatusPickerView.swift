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
        Picker("View Status", selection: $selectedStatus) {
            ForEach(Array(T.tabItems)) { status in
                Text(status.description)
            }
        }
        .pickerStyle(.segmented)
    }
}

struct StatusPickerView_Previews: PreviewProvider {
    static var previews: some View {
        StatusPickerView(selectedStatus: .constant(AnimeWatchListStatus.watching))
    }
}
