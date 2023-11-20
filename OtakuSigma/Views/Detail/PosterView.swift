//
//  PosterView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/24/23.
//

import SwiftUI

struct PosterView: View {
    let imageURL: String?
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        Group {
            if let imageURL = imageURL {
                AsyncImage(url: URL(string: imageURL)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: width, height: height)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
//                        .overlay {
//                            RoundedRectangle(cornerRadius: 5)
//                                .stroke(.secondary)
//                        }
//                        .shadow(radius: 2)
                } placeholder: {
                    ProgressView()
                }
            } else {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color(.placeholderText))
            }
        }
    }
}

struct PosterView_Previews: PreviewProvider {
    static var previews: some View {
        PosterView(imageURL: sampleAnimes[0].mainPicture.medium, width: 100, height: 140)
            .frame(width: 85, height: 135)
    }
}

