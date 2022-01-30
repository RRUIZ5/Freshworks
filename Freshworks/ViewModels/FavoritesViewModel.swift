//
//  FavoritesViewModel.swift
//  Freshworks
//
//  Created by Rodrigo Ruiz Murguia on 29/01/22.
//
import UIKit

enum FavoritesControllerAction {
    case firstLoad
    case grid
    case list
}

class FavoritesViewModel: GifCellDelegate {

    var collectionViewLayout: UICollectionViewLayout { collectionViewConfig.collectionViewLayout() }
    var cellRegistration: GifCellRegistration { collectionViewConfig.cellRegistration() }
    @MainActor @Published var gifs: [GifCellViewModel] = []

    private let collectionViewConfig: GifCollectionViewConfiguration
    private let favoriteManager: FavoriteManager

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
                print("grid")
            case .list:
                print("list")
        }
    }

    @MainActor
    private func update(gifs: [GifCellViewModel]) {
        self.gifs = gifs
    }

    @MainActor
    private func replace(at index: Int, with gif: GifCellViewModel) {
        gifs[index] = gif
    }

    @MainActor
    private func index(of gifId: String) -> Int? {
        gifs.firstIndex { cellViewModel in
            cellViewModel.gif.id == gifId
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

    private func performFavorited(gif: GiphyData, favorited: Bool) {
        Task {
            favorited ?
            favoriteManager.addToFavorites(gif: gif) :
            favoriteManager.removeFromFavorites(gif: gif)

            if let index = await index(of: gif.id) {
                let cellViewModel = GifCellViewModel(gif: gif,
                                                     isFavorited: favoriteManager.isFavorite(gif: gif),
                                                     delegate: self)

                await replace(at: index, with: cellViewModel)
            }
        }
    }

    // MARK: - GifCellDelegate conformance
    func performed(gifCellAction: GifCellAction) {
        switch gifCellAction {
            case .favorited:
                return // This case is not handled by this viewModel
            case .unfavorited(let gif):
                performFavorited(gif: gif, favorited: false)
        }
    }
}
