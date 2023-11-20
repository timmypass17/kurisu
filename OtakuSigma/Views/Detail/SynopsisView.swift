//
//  SynopsisView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/15/23.
//

import SwiftUI

struct SynopsisView: View {
    @State var showMore = false
    let text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Synopsis".uppercased())
            
            Text(text)
                .fixedSize(horizontal: false, vertical: true) // fixes text from being truncated "..." somehow
                .lineLimit(showMore ? nil : 4)
            
            Button(action: {
                withAnimation {
                    showMore.toggle()
                }
            }) {
                HStack(alignment: .firstTextBaseline, spacing:  4) {
                    Text(showMore ? "Show less" : "Show more")
                        .padding(.top, 2)
                    Image(systemName: showMore ? "chevron.up" : "chevron.down")
                }
                .foregroundColor(.accentColor)
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 4)
                .fill(.regularMaterial)
        }
    }
}

#Preview {
    SynopsisView(text: "Awesome synopsis here")
}
