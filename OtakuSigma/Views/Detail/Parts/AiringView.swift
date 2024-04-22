//
//  AiringStatusView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/24/23.
//

import SwiftUI

struct AiringView: View {
    let status: MediaStatus
    
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            Circle()
                .fill(status.color)
                .frame(width: 5)
                .padding(.top, 2)
            
            Text(status.description)
                .font(.system(size: 10))
                .lineLimit(1)
        }
        .padding(.vertical, 2)
        .padding(.horizontal, 4)
        .background{
            RoundedRectangle(cornerRadius: 2)
                .fill(.regularMaterial)
        }
    }
}



