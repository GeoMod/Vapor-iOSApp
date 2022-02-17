//
//  AddUpdateViewModel.swift
//  YT-Vapor-iOSApp
//
//  Created by Daniel O'Leary on 2/3/22.
//

import SwiftUI

final class AddUpdateViewModel: ObservableObject {
	@Published var songTitle = ""

	var songID: UUID?

	var isUpdating: Bool {
		songID != nil
	}

	var buttonTitle: String {
		songID != nil ? "Update Song" : "Add Song"
	}

	init() {
		// No current song, so we're adding a new one.
	}

	init(currentSong: Song) {
		// Passing in an existing song and its info.
		self.songTitle = currentSong.title
		self.songID = currentSong.id
	}


	func addUpdateAction(completion: @escaping () -> Void) {
		Task {
			do {
				if isUpdating {
					try await updateSong()
				} else {
					try await addSong()
				}
			} catch {
				print("❌ Error: \(error)")
			}
			completion()
		}
	}

	func updateSong() async throws {
		let urlString = Constants.baseURL + Endpoints.songs
		guard let url = URL(string: urlString) else {
			throw HttpError.badURL
		}

		let songToUpdate = Song(id: songID, title: songTitle)
		try await HttpClient.shared.sendData(to: url, object: songToUpdate, httpMethod: HttpMethods.PUT.rawValue)
	}


	func addSong() async throws {
		let urlString = Constants.baseURL + Endpoints.songs

		guard let url = URL(string: urlString) else {
			throw HttpError.badURL
		}

		let song = Song(id: nil, title: songTitle)

		try await HttpClient.shared.sendData(to: url, object: song, httpMethod: HttpMethods.POST.rawValue)
	}



}
