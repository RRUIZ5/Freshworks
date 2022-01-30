//
//  GiphyApiMock.swift
//  Freshworks
//
//  Created by Rodrigo Ruiz Murguia on 27/01/22.
//

class GiphyApiMock: GiphyApi {

    let mockData: [GiphyData]

    init(mockData: [GiphyData]) {
        self.mockData = mockData
    }

    func search(query: String) async throws -> [GiphyData] {
        mockData
    }

    func trending() async throws -> [GiphyData] {
        mockData
    }

}
