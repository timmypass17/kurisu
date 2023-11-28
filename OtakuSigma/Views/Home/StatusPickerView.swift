//
//  StatusPickerView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/31/23.
//

import Foundation
import SwiftUI

struct StatusPickerView<T: MediaStatus>: View {
    @Binding var selectedStatus: T
    
    var body: some View {
        Picker("View Status", selection: $selectedStatus) {
            ForEach(Array(T.allCases)) { status in
                Text(status.rawValue.capitalized.replacingOccurrences(of: "_", with: " "))
            }
        }
        .pickerStyle(.segmented)
    }
}

struct StatusPickerView_Previews: PreviewProvider {
    static var previews: some View {
        StatusPickerView(selectedStatus: .constant(AnimeStatus.watching))
    }
}
