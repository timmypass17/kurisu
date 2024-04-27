//
//  AddMediaView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/20/23.
//

import SwiftUI

struct AddMediaView<T: Media>: View {
    @EnvironmentObject var mediaDetailViewModel: MediaDetailViewModel<T>
    @Environment(\.dismiss) private var dismiss
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    let media: T
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                WatchListCell(item: media)
                
                Divider()
                    .padding(.bottom, 8)
                
                Text("Status")
                    .font(.system(size: 18))
                    .bold()
                
                VStack {
                    HStack {
                        Spacer()
                        
                        if media is Anime {
                            Button {
                                mediaDetailViewModel.selectedStatus = .watching
                            } label: {
                                Text("\(SelectedStatus.watching.rawValue.capitalized.replacingOccurrences(of: "_", with: " "))")
                            }
                            .buttonStyle(StatusButton(isSelected: mediaDetailViewModel.selectedStatus == .watching))
                        } else {
                            Button {
                                mediaDetailViewModel.selectedStatus = .reading
                            } label: {
                                Text("\(SelectedStatus.reading.rawValue.capitalized.replacingOccurrences(of: "_", with: " "))")
                            }
                            .buttonStyle(StatusButton(isSelected: mediaDetailViewModel.selectedStatus == .reading))
                        }
                        
                        
                        Button {
                            mediaDetailViewModel.selectedStatus = .completed
                            
                        } label: {
                            Text("\(SelectedStatus.completed.rawValue.capitalized.replacingOccurrences(of: "_", with: " "))")
                        }
                        .buttonStyle(StatusButton(isSelected: mediaDetailViewModel.selectedStatus == .completed))
                        
                        
                        Button {
                            mediaDetailViewModel.selectedStatus = .on_hold
                            
                        } label: {
                            Text("\(SelectedStatus.on_hold.rawValue.capitalized.replacingOccurrences(of: "_", with: " "))")
                        }
                        .buttonStyle(StatusButton(isSelected:  mediaDetailViewModel.selectedStatus == .on_hold))
                        
                        
                        Spacer()
                        
                    }
                    HStack {
                        Spacer()
                        
                        Button {
                            mediaDetailViewModel.selectedStatus = .dropped
                            
                        } label: {
                            Text("\(SelectedStatus.dropped.rawValue.capitalized.replacingOccurrences(of: "_", with: " "))")
                        }
                        .buttonStyle(StatusButton(isSelected:  mediaDetailViewModel.selectedStatus == .dropped))
                        
                        if  media is Anime {
                            Button {
                                mediaDetailViewModel.selectedStatus = .plan_to_watch
                                
                            } label: {
                                Text("\(SelectedStatus.plan_to_watch.rawValue.capitalized.replacingOccurrences(of: "_", with: " "))")
                            }
                            .buttonStyle(StatusButton(isSelected:  mediaDetailViewModel.selectedStatus == .plan_to_watch))
                        } else {
                            Button {
                                mediaDetailViewModel.selectedStatus = .plan_to_read
                                
                            } label: {
                                Text("\(SelectedStatus.plan_to_read.rawValue.capitalized.replacingOccurrences(of: "_", with: " "))")
                            }
                            .buttonStyle(StatusButton(isSelected:  mediaDetailViewModel.selectedStatus == .plan_to_read))
                        }
                        
                        
                        Spacer()
                        
                    }
                }
                .frame(maxWidth: .infinity)
                
                Divider()
                    .padding(.vertical, 8)
                
                
                Text(media.episodeOrChapterString())
                    .font(.system(size: 18))
                    .bold()
                
                if media.numEpisodesOrChapters == 0 {
                    ProgressStepper(progress: $mediaDetailViewModel.progress, media: media)
                } else {
                    ProgressSliderView(progress: $mediaDetailViewModel.progress, media: media)
                }
                
                
                Divider()
                    .padding(.vertical, 8)
                
                Text("Score")
                    .font(.system(size: 18))
                    .bold()
                
                ScoreSliderView(progress: $mediaDetailViewModel.score)
                
                Divider()
                    .padding(.vertical, 8)
                
                Text("Notes")
                    .font(.system(size: 18))
                    .bold()
                
                
                TextField("Write your thoughts here...",
                          text: $mediaDetailViewModel.comments,
                          axis: .vertical)
                
            }
            .padding()
            .navigationTitle(media.getTitle())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        Task {
                            
                            dismiss()
                            
                            await mediaDetailViewModel.didTapSaveButton()
                        }
                    } label: {
                        Text("Save")
                    }
                    
                }
                
                
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
            
            if mediaDetailViewModel.isInUserList {
                Button("Delete", role: .destructive) {
                    Task {
                        await mediaDetailViewModel.didTapDeleteButton()
                        dismiss()
                    }
                }
            }
        }
        .environmentObject( mediaDetailViewModel)
        .background(Color.ui.background)

    }
}

//#Preview("AddMediaView") {
//    NavigationStack {
//        AddMediaView(addMediaViewModel: AddMediaViewModel(media: sampleAnimes[0]), didSaveMedia: {_ in })
//    }
//}

struct StatusButton: ButtonStyle {
    var isSelected: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        Group {
            if isSelected {
                configuration.label
                    .foregroundStyle(.white)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.blue)
                    }
            } else {
                configuration.label
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.regularMaterial)
                    }
            }
        }
        .font(.system(size: 14))
    }
}
