//
//  HTTPClient.swift
//  YT-Vapor-iOSApp
//
//  Created by Daniel O'Leary on 2/3/22.
//

import Foundation

enum HttpMethods: String {
	case POST
	case GET
	case PUT
	case DELETE
}

enum MIMIType: String {
	case JSON = "application/json"
}

enum HttpHeaders: String {
	case contentType = "Content-Type"
}

enum HttpError: Error {
	case badURL
	case badResponse
	case errorDecodingData
	case invalidURL
}

class HttpClient {
	private init() { }

	static let shared = HttpClient()

	// func is generic so it can be used in any app making http requests.
	func fetch<T: Codable>(url: URL) async throws -> [T] {
		let (data, response) = try await URLSession.shared.data(from: url)

		guard (response as? HTTPURLResponse)?.statusCode == 200 else {
			throw HttpError.badResponse
		}

		guard let object = try? JSONDecoder().decode([T].self, from: data) else {
			throw HttpError.errorDecodingData
		}

		return object
	}

	func sendData<T: Codable>(to url: URL, object: T, httpMethod: String) async throws {
		var request = URLRequest(url: url)

		request.httpMethod = httpMethod
		request.addValue(MIMIType.JSON.rawValue, forHTTPHeaderField: HttpHeaders.contentType.rawValue)

		// Send data to server
		request.httpBody = try? JSONEncoder().encode(object)

		let (_, response) = try await URLSession.shared.data(for: request)

		guard (response as? HTTPURLResponse)?.statusCode == 200 else {
			throw HttpError.badResponse
		}
	}

	func delete(at id: UUID, url: URL) async throws {
		var request = URLRequest(url: url)
		request.httpMethod = HttpMethods.DELETE.rawValue

		let (_, response) = try await URLSession.shared.data(for: request)

		guard (response as? HTTPURLResponse)?.statusCode == 200 else {
			throw HttpError.badResponse
		}
	}


}
