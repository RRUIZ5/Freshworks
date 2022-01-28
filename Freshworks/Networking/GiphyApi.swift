//
//  GiphyApi.swift
//  Freshworks
//
//  Created by Rodrigo Ruiz Murguia on 27/01/22.
//

protocol GiphyApi {
    func search(query: String) async throws -> SearchResponse
    func trending() async throws -> SearchResponse
}
