//
//  GiphyApiNetwork.swift
//  Freshworks
//
//  Created by Rodrigo Ruiz Murguia on 27/01/22.
//

import Foundation

class GiphyApiNetwork: GiphyApi {

    // This is completely wrong
    // https://nshipster.com/secrets/
    // Doing this for the sake of finishing on time
    private let apiKey = "G8V5l9wElsEQpVIors6hVvF2aJFtvHL3"
    private let networkManager = NetworkManager()

    init() {}

    func search(query: String) async throws -> [GiphyData] {
        try await makeSimpleRequest(endpoint: .search, with: ["q": query])
    }

    func trending() async throws -> [GiphyData] {
        try await makeSimpleRequest(endpoint: .trending)
    }

    private func makeSimpleRequest(endpoint: Endpoint,
                                   with params: [String: String]? = nil) async throws -> [GiphyData] {
        var allParams = ["api_key": apiKey]
        if let params = params {
            allParams.merge(params) { selfApiKey, _ in
                selfApiKey
            }
        }

        let request = try networkManager.request(for: endpoint, with: allParams, using: .get)
        let response: SearchResponse = try await networkManager.make(request: request)

        return Array(Set(response.data))
    }

}
