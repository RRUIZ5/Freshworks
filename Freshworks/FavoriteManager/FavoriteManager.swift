//
//  FavoriteManager.swift
//  Freshworks
//
//  Created by Rodrigo Ruiz Murguia on 29/01/22.
//

class FavoriteManager {

    private var favorites: [String: GiphyData] = [:]

    func addToFavorites(gif: GiphyData) {
        favorites[gif.id] = gif
    }

    func removeFromFavorites(gif: GiphyData) {
        favorites.removeValue(forKey: gif.id)
    }

    func isFavorite(gif: GiphyData) -> Bool {
        favorites[gif.id] != nil
    }

    func allFavorites() -> [String: GiphyData] { favorites }
}
