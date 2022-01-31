//
//  MemoryFavoriteManager.swift
//  Freshworks
//
//  Created by Rodrigo Ruiz Murguia on 30/01/22.
//

actor MemoryFavoriteManager: FavoriteManager {

    private var favorites: [String: GiphyData] = [:]

    func addToFavorites(gif: GiphyData) async {
        favorites[gif.id] = gif
    }

    func removeFromFavorites(gif: GiphyData)  async{
        favorites.removeValue(forKey: gif.id)
    }

    func isFavorite(gif: GiphyData) async -> Bool {
        favorites[gif.id] != nil
    }

    func allFavorites() async -> [GiphyData] {
        favorites.values.map { $0 }
    }
}

