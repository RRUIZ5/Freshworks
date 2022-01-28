//
//  SearchRequest.swift
//  Freshworks
//
//  Created by Rodrigo Ruiz Murguia on 27/01/22.
//

struct SearchRequest: Codable {
    let query: String
    let lang: String = "en"

    enum CodingKeys: String, CodingKey {
        case query = "q"
    }
}
