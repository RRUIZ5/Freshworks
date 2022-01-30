//
//  FavoritesViewModel.swift
//  Freshworks
//
//  Created by Rodrigo Ruiz Murguia on 29/01/22.
//

import UIKit

class FavoritesViewModel: GifViewModel {
    let removeOnUnfavorite = true

    @MainActor @Published var gifs: [GifCellViewModel] = []
    @Published var collectionViewConfig: GifCollectionViewConfiguration
    
    let favoriteManager: FavoriteManager

    init(collectionViewConfig: GifCollectionViewConfiguration = GifCollectionViewConfiguration(layout: .grid),
         favoriteManager: FavoriteManager = FavoriteManager()) {
        self.collectionViewConfig = collectionViewConfig
        self.favoriteManager = favoriteManager
    }

    func searchEvent(action: FavoritesControllerAction) {
        switch action {
            case .firstLoad:
                firstLoad()
            case .grid:
                change(layout: .grid)
            case .list:
                change(layout: .list)
        }
    }

    private func firstLoad() {
        Task {
            let allFavorites = favoriteManager.allFavorites()
                .map { gif in
                    GifCellViewModel(gif: gif,
                                     isFavorited: true,
                                     delegate: self)
                }
            await update(gifs: allFavorites)
        }
    }

    private func change(layout: GifCollectionViewConfiguration.GifCollectionViewLayout) {
        collectionViewConfig = GifCollectionViewConfiguration(layout: layout)
    }
}
