//
//  GiphyApiMock.swift
//  Freshworks
//
//  Created by Rodrigo Ruiz Murguia on 27/01/22.
//

class GiphyApiMock: GiphyApi {

    let mockResponse: SearchResponse

    init(mockResponse: SearchResponse) {
        self.mockResponse = mockResponse
    }

    func search(query: String) async throws -> SearchResponse {
        mockResponse
    }

    func trending() async throws -> SearchResponse {
        mockResponse
    }

}
