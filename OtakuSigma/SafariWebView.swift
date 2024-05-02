//
//  SafariWebView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 5/1/24.
//

import SafariServices
import SwiftUI

struct SafariWebView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {

    }
    
}
