//
//  MediaStatusView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 4/21/24.
//

import SwiftUI

struct MediaStatusView: View {
    var item: Media
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: item.status.systemImage)
            Text(item.getStatusString())
        }
        .foregroundColor(.secondary)
        .font(.caption)
    }
}
