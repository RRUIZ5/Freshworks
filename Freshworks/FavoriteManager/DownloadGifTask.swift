//
//  DownloadGifTask.swift
//  Freshworks
//
//  Created by Rodrigo Ruiz Murguia on 30/01/22.
//

import Foundation

struct DownloadGifTask: Identifiable {
    let uuid: UUID
    let id: String
    let url: URL
    let type: GifType

    init(id: String, url: URL, type: GifType, uuid: UUID = UUID()) {
        self.uuid = uuid
        self.id = id
        self.url = url
        self.type = type
    }

    func run(networkManager: NetworkManager) async throws -> DownloadedGif {
        let request = URLRequest(url: url)
        let data = try await networkManager.make(request: request)

        return DownloadedGif(id: id, type: type, data: data)
    }
}
