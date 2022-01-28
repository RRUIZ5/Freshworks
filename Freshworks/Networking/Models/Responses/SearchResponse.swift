//
//  SearchResponse.swift
//  Freshworks
//
//  Created by Rodrigo Ruiz Murguia on 27/01/22.
//

struct SearchResponse: Codable {
    let data: [GiphyData]
}

struct GiphyData: Codable {
    let title: String
    let images: Images
}

struct Images: Codable {
    let fixedHeight: FixedImage
    let fixedWidth: FixedImage
    let original: OriginalImage
}

struct FixedImage: Codable {
    let url: String
    let width: String
    let height: String
    let mp4: String
    let webp: String
}

struct OriginalImage: Codable {
    let height: String
    let mp4: String
    let webp: String
}
