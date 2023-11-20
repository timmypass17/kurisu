//
//  DetailTabView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/15/23.
//

import SwiftUI

enum DetailTab: String, CaseIterable, Identifiable {
    case background, info, statistic
    var id: Self { self }
}

struct DetailTabView: View {
    @Binding var selectedTab: DetailTab
    
    var body: some View {
        Picker("View Mode", selection: $selectedTab) {
            ForEach(DetailTab.allCases) { mode in
                Text(mode.rawValue.capitalized)
            }
        }
        .pickerStyle(.segmented)
    }
}

struct DetailTabView_Previews: PreviewProvider {
    static var previews: some View {
        DetailTabView(selectedTab: .constant(.background))
    }
}
