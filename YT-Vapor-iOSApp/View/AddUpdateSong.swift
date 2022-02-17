//
//  AddUpdateSong.swift
//  YT-Vapor-iOSApp
//
//  Created by Daniel O'Leary on 2/3/22.
//

import SwiftUI

struct AddUpdateSong: View {
	@Environment(\.dismiss) var dismiss

	@ObservedObject var viewModel: AddUpdateViewModel

    var body: some View {
		VStack {
			TextField("song title", text: $viewModel.songTitle)
				.textFieldStyle(.roundedBorder)
				.padding()

			Button {
				viewModel.addUpdateAction {
					// Called by the completion handler of the `addUpdateAction` method
					dismiss()
				}
			} label: {
				Text(viewModel.buttonTitle)
			}

		}
    }
}

struct AddUpdateSong_Previews: PreviewProvider {
    static var previews: some View {
		AddUpdateSong(viewModel: AddUpdateViewModel())
    }
}
