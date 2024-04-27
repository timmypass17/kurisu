//
//  DiscoverDetailCellView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/6/23.
//

import SwiftUI


struct DiscoverDetailCellView: View {
    let item: Media
    var width: CGFloat
    var height: CGFloat {
        ((85 * width) / 135) * 2.5
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            AsyncImage(url: URL(string: item.mainPicture.large)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color(uiColor: UIColor.tertiarySystemFill)
            }
            .frame(width: width, height: height)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            
//            AsyncImage(url: URL(string: item.mainPicture.medium)) { image in
//                image
//                    .resizable()
//                    .aspectRatio(2/3, contentMode: .fit)    // TODO: Some images get stretched
//                    .scaledToFill()
//            } placeholder: {
//                ProgressView()
//            }
//            .clipShape(RoundedRectangle(cornerRadius: 5))

            Text(item.getTitle())
                .font(.system(size: 14))
                .lineLimit(1)
                .padding(.top, 4)

            Text("TV - 12 Episodes")
                .foregroundColor(.secondary)
                .font(.system(size: 10))
            
            AiringView(status: item.status)
                .padding(.top, 2)
//            StatusView(status: item.status.description, color: .green)
//                .padding(.top, 2)
                        
        }
    }
}

//struct DiscoverDetailCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        DiscoverDetailCellView(item: sampleAnimes[0])
//    }
//}
