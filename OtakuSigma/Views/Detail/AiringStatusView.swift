//
//  AiringStatusView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/24/23.
//

import SwiftUI

struct AiringStatusView: View {
    let status: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            Circle()
                .fill(.green)
//                .fill(item.getAiringStatusColor())
                .frame(width: 5)
                .padding(.top, 2)
            
            Text(status)
                .font(.system(size: 10))
                .lineLimit(1)
//                .foregroundColor(Color.ui.textColor)
        }
        .padding(.vertical, 2)
        .padding(.horizontal, 4)
        .background{
            RoundedRectangle(cornerRadius: 2)
                .fill(.regularMaterial)
        }
    }
}

struct AnimeStatus_Previews: PreviewProvider {
    static var previews: some View {
        AiringStatusView(status: sampleAnimes[0].status.description)
    }
}
