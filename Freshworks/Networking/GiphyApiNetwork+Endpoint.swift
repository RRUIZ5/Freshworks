//
//  GiphyApiNetwork+Endpoint.swift
//  Freshworks
//
//  Created by Rodrigo Ruiz Murguia on 27/01/22.
//

import Foundation

extension GiphyApiNetwork {
    enum Endpoint: String, URLConvertible {
        static let path = "https://api.giphy.com/v1/gifs/"

        case search = "search"
        case trending = "trending"

        var url: URL? {
            URL(string: "\(GiphyApiNetwork.Endpoint.path)\(self)")
        }
    }
}
