//
//  AddMediaView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/20/23.
//

import SwiftUI

struct AddMediaView<T: Media>: View {
    let media: T
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Episode Progression")
                    .font(.title)
                    .bold()
            }
            
            Text("Keep track of episodes watched!")
                .foregroundColor(.secondary)
            
//            WatchListCell(item: UserNode(node: media, listStatus: media.myListStatus))
//                .padding(.top)
//                .padding(.bottom, 8)
                            
                Divider()
                    .padding(.bottom, 8)
                
                // TODO: Turn this into 1 view
//                if anime.getNumEpisodes() > 0 {
//                    ProgressionSlider(
//                        item: anime,
//                        progress: $progress,
//                        maxEpisodeOrChapter: anime.getNumEpisodes()
//                    )
//                } else {
//                    ProgressionStepper(
//                        item: anime,
//                        progress: $progress,
//                        maxEpisodeOrChapter: anime.getNumEpisodes()
//                    )
//                }
            
            Spacer()
            
//            Button{
//                print("")
//            } {
//                // save to icloud
//                Group {
////                    if isLoading {
////                        ProgressView()
////                    } else {
//                        Text("Save")
////                    }
//                }
//                .foregroundColor(.white)
//                .frame(maxWidth: .infinity, minHeight: 40)
//                .background(Color.accentColor)
//                .cornerRadius(10)
//            }
            .buttonStyle(.plain)
//            .disabled(isLoading)
        }
        .padding()
        .padding(.top)
//        .alert(isPresented: $appState.showAlert) {
//            switch appState.activeAlert {
//            case .iCloudNotLoggedIn:
//                return Alert(
//                    title: Text("Unable to save progress!"),
//                      message: Text("Please verify that you are logged into your iCloud account by going to Settings > iCloud on your device.")
//                )
//            }
//        }
    }
}

//#Preview {
//    AddMediaView()
//}
