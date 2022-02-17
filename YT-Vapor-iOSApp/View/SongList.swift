//
//  ContentView.swift
//  YT-Vapor-iOSApp
//
//  Created by Daniel O'Leary on 2/3/22.
//

import SwiftUI

struct SongList: View {
	@StateObject var viewModel = SongListViewModel()
	@State private var modal: ModalType? = nil

    var body: some View {
		NavigationView {
			List {
				ForEach(viewModel.songs) { song in
					Button {
						modal = .update(song)
					} label: {
						Text(song.title)
							.font(.title3)
					}
					.buttonStyle(.bordered)
					.foregroundColor(.accentColor)

				}.onDelete(perform: viewModel.delete)
			}
			.toolbar {
				Button {
					modal = .add
				} label: {
					Label("Add Song", systemImage: "plus.circle")
				}
				.buttonStyle(.bordered)
				.foregroundColor(.green)
			}
			.navigationTitle(Text("Songs"))
		}

		.sheet(item: $modal, onDismiss: {
			// called on Dismiss to refresh song list.
			Task {
				do {
					try await viewModel.fetchSongs()
				} catch {
					print("❌ Error: \(error)")
				}
			}
		}, content: { modal in
			switch modal {
				case .add:
					AddUpdateSong(viewModel: AddUpdateViewModel())
				case .update(let song):
					AddUpdateSong(viewModel: AddUpdateViewModel(currentSong: song))
			}
		})

		.onAppear {
			Task {
				do {
					try await viewModel.fetchSongs()
				} catch {
					print("❌ Error: \(error)")
				}
			}
		}
    }

}



struct SongList_Previews: PreviewProvider {
    static var previews: some View {
        SongList()
    }
}
