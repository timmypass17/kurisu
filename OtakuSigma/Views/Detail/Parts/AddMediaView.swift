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
                        
                        if let selectedAnimeStatus = mediaDetailViewModel.selectedStatus as? SelectedAnimeStatus {
                            Button {
                                mediaDetailViewModel.selectedStatus = SelectedAnimeStatus.watching
                            } label: {
                                Text("\(SelectedAnimeStatus.watching.value.capitalized.replacingOccurrences(of: "_", with: " "))")
                            }
                            .buttonStyle(StatusButton(isSelected: selectedAnimeStatus == .watching))
                            
                            Button {
                                mediaDetailViewModel.selectedStatus = SelectedAnimeStatus.completed
                                
                            } label: {
                                Text("\(SelectedAnimeStatus.completed.value.capitalized.replacingOccurrences(of: "_", with: " "))")
                            }
                            .buttonStyle(StatusButton(isSelected: selectedAnimeStatus == .completed))
                            
                            Button {
                                mediaDetailViewModel.selectedStatus = SelectedAnimeStatus.on_hold
                                
                            } label: {
                                Text("\(SelectedAnimeStatus.on_hold.value.capitalized.replacingOccurrences(of: "_", with: " "))")
                            }
                            .buttonStyle(StatusButton(isSelected: selectedAnimeStatus == .on_hold))
                        } else if let selectedMangaStatus = mediaDetailViewModel.selectedStatus as? SelectedMangaStatus {
                            Button {
                                mediaDetailViewModel.selectedStatus = SelectedMangaStatus.reading
                            } label: {
                                Text("\(SelectedMangaStatus.reading.value.capitalized.replacingOccurrences(of: "_", with: " "))")
                            }
                            .buttonStyle(StatusButton(isSelected: selectedMangaStatus == .reading))
                            
                            Button {
                                mediaDetailViewModel.selectedStatus = SelectedMangaStatus.completed
                                
                            } label: {
                                Text("\(SelectedMangaStatus.completed.value.capitalized.replacingOccurrences(of: "_", with: " "))")
                            }
                            .buttonStyle(StatusButton(isSelected: selectedMangaStatus == .completed))
                            
                            Button {
                                mediaDetailViewModel.selectedStatus = SelectedMangaStatus.on_hold
                            } label: {
                                Text("\(SelectedMangaStatus.on_hold.value.capitalized.replacingOccurrences(of: "_", with: " "))")
                            }
                            .buttonStyle(StatusButton(isSelected: selectedMangaStatus == .on_hold))
                        }

                        Spacer()
                        
                    }
                    HStack {
                        Spacer()
                        
                        if let selectedAnimeStatus = mediaDetailViewModel.selectedStatus as? SelectedAnimeStatus {

                            Button {
                                mediaDetailViewModel.selectedStatus = SelectedAnimeStatus.dropped
                                
                            } label: {
                                Text("\(SelectedAnimeStatus.dropped.value.capitalized.replacingOccurrences(of: "_", with: " "))")
                            }
                            .buttonStyle(StatusButton(isSelected:  selectedAnimeStatus == .dropped))
                            
                            Button {
                                mediaDetailViewModel.selectedStatus = SelectedAnimeStatus.plan_to_watch
                                
                            } label: {
                                Text("\(SelectedAnimeStatus.plan_to_watch.value.capitalized.replacingOccurrences(of: "_", with: " "))")
                            }
                            .buttonStyle(StatusButton(isSelected:  selectedAnimeStatus == .plan_to_watch))
                        } else if let selectedMangaStatus = mediaDetailViewModel.selectedStatus as? SelectedMangaStatus {
                            Button {
                                mediaDetailViewModel.selectedStatus = SelectedMangaStatus.dropped
                                
                            } label: {
                                Text("\(SelectedMangaStatus.dropped.value.capitalized.replacingOccurrences(of: "_", with: " "))")
                            }
                            .buttonStyle(StatusButton(isSelected:  selectedMangaStatus == .dropped))
                            
                            Button {
                                mediaDetailViewModel.selectedStatus = SelectedMangaStatus.plan_to_read
                                
                            } label: {
                                Text("\(SelectedMangaStatus.plan_to_read.value.capitalized.replacingOccurrences(of: "_", with: " "))")
                            }
                            .buttonStyle(StatusButton(isSelected:  selectedMangaStatus == .plan_to_read))
                        }
                        
                        Spacer()
                        
                    }
                }
                .frame(maxWidth: .infinity)
                
                Divider()
                    .padding(.vertical, 8)
                
                
                Text(media.getEpisodeOrChapterString().capitalized)
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
                
                if mediaDetailViewModel.isInUserList {
                    Button("Remove from list", role: .destructive) {
                        mediaDetailViewModel.isShowingConfirmationDialog.toggle()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 75)
                }
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
            .confirmationDialog("Remove \"\(media.getTitle())\"",
                                isPresented: $mediaDetailViewModel.isShowingConfirmationDialog,
                                titleVisibility: .visible) {
                Button("Yes") {
                    dismiss()
                    Task {
                        await mediaDetailViewModel.didTapDeleteButton()
                    }
                }
                Button("No", role: .destructive) { }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to remove this item from your collection?")
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
