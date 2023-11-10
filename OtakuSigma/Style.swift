//
//  Style.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/31/23.
//

import Foundation
import SwiftUI

struct BorderedTag: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 2)
            .padding(.horizontal, 4)
            .background{
                RoundedRectangle(cornerRadius: 2)
                    .fill(.regularMaterial)
                //                .fill(Color.ui.tag)
            }
    }
}

extension View {
    func borderedTag() -> some View {
        modifier(BorderedTag())
    }
}
