//
//  DiscoverCellView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/1/23.
//

import SwiftUI

struct DiscoverCellView: View {
    let item: Media
    var width: CGFloat = 100
    var height: CGFloat = 150

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            AsyncImage(url: URL(string: item.mainPicture.medium)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
//                    .overlay {
//                        RoundedRectangle(cornerRadius: 5)
//                            .stroke(.secondary)
//                    }
//                    .shadow(radius: 2)
            } placeholder: {
                ProgressView()
            }
            .frame(width: width, height: height)
            
            Text(item.title)
                .font(.system(size: 14))
                .lineLimit(1)
                .padding(.top, 4)

            Text("TV - 12 Episodes")
                .foregroundColor(.secondary)
                .font(.system(size: 10))
            
            StatusView(status: item.status, color: .green)
                .padding(.top, 2)
                        
        }
        .frame(width: width)
//        .contentShape(RoundedRectangle(cornerRadius: 5)) // fixes overlap click area
    }
}

struct StatusView: View {
    let status: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 5)
                .padding(.top, 2)
            
            Text(status)
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

struct DiscoverCellView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            DiscoverCellView(item: sampleAnimes[0])
        }
    }
}
