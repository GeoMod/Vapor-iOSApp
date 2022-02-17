//
//  SongListViewModel.swift
//  YT-Vapor-iOSApp
//
//  Created by Daniel O'Leary on 2/3/22.
//

import SwiftUI

class SongListViewModel: ObservableObject {
	@Published var songs = [Song]()

	func fetchSongs() async throws {
		let urlString = Constants.baseURL + Endpoints.songs

		guard let url = URL(string: urlString) else {
			throw HttpError.badURL
		}

		let songResponse: [Song] = try await HttpClient.shared.fetch(url: url)

		DispatchQueue.main.async {
			self.songs = songResponse
		}
	}

	func delete(at offsets: IndexSet) {
		offsets.forEach { index in
			guard let songID = songs[index].id else {
				return
			}

			guard let url = URL(string: Constants.baseURL + Endpoints.songs + "/\(songID)") else {
				return
			}

			Task {
				do {
					try await HttpClient.shared.delete(at: songID, url: url)
				} catch {
					print("❌ Error: \(error)")
				}
			}

		}

		// remove song from @Published `songs` array value
		songs.remove(atOffsets: offsets)
	}

}

