//
//  Song.swift
//  YT-Vapor-iOSApp
//
//  Created by Daniel O'Leary on 2/3/22.
//

import Foundation

struct Song: Identifiable, Codable {
	let id: UUID?
	var	title: String	
}
