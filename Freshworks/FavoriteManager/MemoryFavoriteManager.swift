//
//  MemoryFavoriteManager.swift
//  Freshworks
//
//  Created by Rodrigo Ruiz Murguia on 30/01/22.
//

import Combine

actor MemoryFavoriteManager: FavoriteManager {

    nonisolated var actionPublisher: AnyPublisher<FavoriteManagerAction, Never> {
        publisher.eraseToAnyPublisher()
    }

    let publisher = PassthroughSubject<FavoriteManagerAction, Never>()
    private var favorites: [String: GiphyData] = [:]

    func addToFavorites(gif: GiphyData) async {
        favorites[gif.id] = gif
        publisher.send(.favorited(id: gif.id))
    }

    func removeFromFavorites(gif: GiphyData)  async{
        favorites.removeValue(forKey: gif.id)
        publisher.send(.unfavorited(id: gif.id))
    }

    func isFavorite(gif: GiphyData) async -> Bool {
        favorites[gif.id] != nil
    }

    func allFavorites() async -> [GiphyData] {
        favorites.values.map { $0 }
    }
}

