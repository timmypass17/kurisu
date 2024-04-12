//
//  AddMediaView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/20/23.
//

import SwiftUI

struct AddMediaView<T: Media>: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var addMediaViewModel: AddMediaViewModel<T>
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                WatchListCell(item: addMediaViewModel.media)
                
                Divider()
                    .padding(.bottom, 8)
                
                Text("Status")
                    .font(.system(size: 18))
                    .bold()
                
                VStack {
                    HStack {
                        Spacer()
                        
                        if addMediaViewModel.media is Anime {
                            Button {
                                addMediaViewModel.selectedStatus = .watching
                            } label: {
                                Text("\(SelectedStatus.watching.rawValue.capitalized.replacingOccurrences(of: "_", with: " "))")
                            }
                            .buttonStyle(StatusButton(isSelected: addMediaViewModel.selectedStatus == .watching))
                        } else {
                            Button {
                                addMediaViewModel.selectedStatus = .reading
                            } label: {
                                Text("\(SelectedStatus.reading.rawValue.capitalized.replacingOccurrences(of: "_", with: " "))")
                            }
                            .buttonStyle(StatusButton(isSelected: addMediaViewModel.selectedStatus == .reading))
                        }
                        
                        
                        Button {
                            addMediaViewModel.selectedStatus = .completed
                            
                        } label: {
                            Text("\(SelectedStatus.completed.rawValue.capitalized.replacingOccurrences(of: "_", with: " "))")
                        }
                        .buttonStyle(StatusButton(isSelected: addMediaViewModel.selectedStatus == .completed))
                        
                        
                        Button {
                            addMediaViewModel.selectedStatus = .on_hold
                            
                        } label: {
                            Text("\(SelectedStatus.on_hold.rawValue.capitalized.replacingOccurrences(of: "_", with: " "))")
                        }
                        .buttonStyle(StatusButton(isSelected: addMediaViewModel.selectedStatus == .on_hold))
                        
                        
                        Spacer()
                        
                    }
                    HStack {
                        Spacer()
                        
                        Button {
                            addMediaViewModel.selectedStatus = .dropped
                            
                        } label: {
                            Text("\(SelectedStatus.dropped.rawValue.capitalized.replacingOccurrences(of: "_", with: " "))")
                        }
                        .buttonStyle(StatusButton(isSelected: addMediaViewModel.selectedStatus == .dropped))
                        
                        if addMediaViewModel.media is Anime {
                            Button {
                                addMediaViewModel.selectedStatus = .plan_to_watch
                                
                            } label: {
                                Text("\(SelectedStatus.plan_to_watch.rawValue.capitalized.replacingOccurrences(of: "_", with: " "))")
                            }
                            .buttonStyle(StatusButton(isSelected: addMediaViewModel.selectedStatus == .plan_to_watch))
                        } else {
                            Button {
                                addMediaViewModel.selectedStatus = .plan_to_read
                                
                            } label: {
                                Text("\(SelectedStatus.plan_to_read.rawValue.capitalized.replacingOccurrences(of: "_", with: " "))")
                            }
                            .buttonStyle(StatusButton(isSelected: addMediaViewModel.selectedStatus == .plan_to_read))
                        }
                        
                        
                        Spacer()
                        
                    }
                }
                .frame(maxWidth: .infinity)
                
                Divider()
                    .padding(.vertical, 8)
                
                
                Text(T.episodesOrChaptersString)
                    .font(.system(size: 18))
                    .bold()
                
                ProgressSliderView(media: addMediaViewModel.media, progress: $addMediaViewModel.progress)
                
                Divider()
                    .padding(.vertical, 8)
                
                Text("Score")
                    .font(.system(size: 18))
                    .bold()
                
                ScoreSliderView(progress: $addMediaViewModel.score)
                
                Divider()
                    .padding(.vertical, 8)
                
                Text("Notes")
                    .font(.system(size: 18))
                    .bold()
                
                TextField("Write your thoughts here...", text: $addMediaViewModel.comments, axis: .vertical)
                
            }
            .padding()
            .navigationTitle(addMediaViewModel.media.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        Task {
                            let updatedMedia = await addMediaViewModel.saveButtonTapped()
                            dismiss()
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
        }
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
struct NoShape: Shape { func path(in rect: CGRect) -> Path { return Path() } }
