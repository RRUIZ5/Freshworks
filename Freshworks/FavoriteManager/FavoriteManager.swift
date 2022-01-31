//
//  FavoriteManager.swift
//  Freshworks
//
//  Created by Rodrigo Ruiz Murguia on 29/01/22.
//

import Foundation

protocol FavoriteManager {
    func addToFavorites(gif: GiphyData) async
    func removeFromFavorites(gif: GiphyData) async
    func isFavorite(gif: GiphyData) async -> Bool
    func allFavorites() async -> [GiphyData]
}
