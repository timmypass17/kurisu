//
//  ProfileCellView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 4/29/24.
//

import SwiftUI

struct ProfileCell: View {
    var title: String
    var description: String
    var systemName: String
    
    var body: some View {
        HStack {
            Image(systemName: systemName)
            Text(title)
            Spacer()
            Text(description)
                .foregroundStyle(.secondary)
        }
    }
}
