//
//  NetworkManager.swift
//  Freshworks
//
//  Created by Rodrigo Ruiz Murguia on 27/01/22.
//

import Foundation

class NetworkManager {

    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder


    init(session: URLSession = URLSession.shared) {
        self.session = session

        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
    }
    
    func make<T: Decodable>(request: URLRequest) async throws -> T {
        let (data, response) = try await session.data(for: request)

        guard let code = (response as? HTTPURLResponse)?.statusCode,
              (200...209).contains(code) else {
                  throw NetworkError(message: "Not 200 response")
              }

        return try decoder.decode(T.self, from: data)
    }

    func request(for endpoint: URLConvertible,
                 with params: [String: String],
                 using method: Method) throws -> URLRequest {

        guard let url = endpoint.url,
              var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                  assert(false, "Bad url, please double check")
              }

        let queryItems = params.map(URLQueryItem.init)
        components.queryItems = queryItems

        guard let finalUrl = components.url else {
            throw NetworkError(message: "Invalid parameters")
        }

        var request = URLRequest(url: finalUrl)
        request.httpMethod = method.rawValue

        return request
    }
}
