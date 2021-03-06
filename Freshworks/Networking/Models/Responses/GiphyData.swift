//
//  GiphyData.swift
//  Freshworks
//
//  Created by Rodrigo Ruiz Murguia on 27/01/22.
//

struct GiphyData: Codable, Hashable {
    let id: String
    let title: String
    let images: Images
}
