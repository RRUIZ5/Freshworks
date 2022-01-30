//
//  GiphyApi.swift
//  Freshworks
//
//  Created by Rodrigo Ruiz Murguia on 27/01/22.
//

protocol GiphyApi {
    func search(query: String) async throws -> [GiphyData]
    func trending() async throws -> [GiphyData]
}
