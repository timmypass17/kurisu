//
//  WatchList.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/22/23.
//

import SwiftUI


struct WatchListView<T: Media, U: ListStatus>: View {
    var items: [UserNode<T, U>]

    var body: some View {
        VStack {
            ForEach(items, id: \.node.id) { item in
                WatchListCell(item: item)
                Divider()
            }
        }
    }
}

//struct WatchListView_Previews: PreviewProvider {
//    static var previews: some View {
//        WatchListView(items: [])
//    }
//}
