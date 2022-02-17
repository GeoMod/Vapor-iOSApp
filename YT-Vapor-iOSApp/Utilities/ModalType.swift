//
//  ModalType.swift
//  YT-Vapor-iOSApp
//
//  Created by Daniel O'Leary on 2/3/22.
//

import Foundation
import Metal

enum ModalType: Identifiable {
	var id: String {
		switch self {
			case .add: return "add"
			case .update: return "update"
		}

	}
	case add
	case update(Song)
}
