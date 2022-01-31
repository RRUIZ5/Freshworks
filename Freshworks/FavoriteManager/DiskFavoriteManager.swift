//
//  DiskFavoriteManager.swift
//  Freshworks
//
//  Created by Rodrigo Ruiz Murguia on 30/01/22.
//

import Combine
import Foundation

enum FavoriteManagerAction {
    case favorited(id: String)
    case unfavorited(id: String)
}

actor DiskFavoriteManager: FavoriteManager {

    nonisolated var actionPublisher: AnyPublisher<FavoriteManagerAction, Never> {
        publisher.eraseToAnyPublisher()
    }

    let publisher = PassthroughSubject<FavoriteManagerAction, Never>()

    private let networkManager: NetworkManager
    private let base: URL
    private let indexPath = "index"

    private var favorites: [String: GiphyData] {
        didSet { writeFavoritesIndex() }
    }

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        base = paths[0]
        let url = paths[0].appendingPathComponent(indexPath)
        if let data = try? Data(contentsOf: url),
            let favorites = try? PropertyListDecoder().decode([String: GiphyData].self, from: data) { // There are previous data, load it
            self.favorites = favorites
        } else { // No previous data, start from scratch
            self.favorites = [:]
        }
    }
    
    func addToFavorites(gif: GiphyData) async {

        do {

            let writtenGifs = try await withThrowingTaskGroup(of: DownloadedGif.self,
                                                              returning: [WrittenGif].self,
                                                              body: { group in

                let tasks = gif.generateDownloadTasks()

                for task in tasks {
                    group.addTask { [networkManager] in
                        try await task.run(networkManager: networkManager)
                    }
                }

                return try await group.map { [base] downloadedGif -> WrittenGif in

                    let relativePath = "\(downloadedGif.id)\(downloadedGif.type)"
                    let diskUrl = base.appendingPathComponent(relativePath)
                    try downloadedGif.data.write(to: diskUrl)
//                    print(diskUrl)

                    return WrittenGif(type: downloadedGif.type, url: diskUrl)

                }.reduce(into: [WrittenGif](), { $0.append($1) })
            })

            guard let savedGif = GiphyData(writtenGifs: writtenGifs, originalGif: gif) else {
                print("Error while creating local GiphyData")
                return
            }

            favorites[savedGif.id] = savedGif
            publisher.send(.favorited(id: savedGif.id))
        } catch {
            print(error)
        }
    }

    func removeFromFavorites(gif: GiphyData) async {

        guard let localGif = favorites[gif.id] else { return }
        Task {
            let urls = [
                localGif.images.downsizedMedium,
                localGif.images.fixedWidth,
                localGif.images.fixedHeight,
            ]

            try urls.forEach { image in
                guard let url = URL(string: image.url),
                      url.isFileURL else { return }
                try FileManager.default.removeItem(at: url)
            }
            favorites.removeValue(forKey: gif.id)
            publisher.send(.unfavorited(id: gif.id))
        }
    }

    func isFavorite(gif: GiphyData) async -> Bool {
        favorites[gif.id] != nil
    }

    func allFavorites() async -> [GiphyData] {
        favorites.values.map { $0 }
    }

    private func writeFavoritesIndex() {
        Task {
            let data = try PropertyListEncoder().encode(favorites)
            let url = base.appendingPathComponent(indexPath)
            try data.write(to: url)
        }
    }
}
