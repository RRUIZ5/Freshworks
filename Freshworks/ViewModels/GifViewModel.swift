//
//  GifViewModel.swift
//  Freshworks
//
//  Created by Rodrigo Ruiz Murguia on 30/01/22.
//

import UIKit

protocol GifViewModel: GifCellDelegate {

    @MainActor var gifs: [GifCellViewModel] { get set }

    var collectionViewConfig: GifCollectionViewConfiguration { get }
    var favoriteManager: FavoriteManager { get }
    var removeOnUnfavorite: Bool { get }

}

extension GifViewModel {

    var collectionViewLayout: UICollectionViewLayout { collectionViewConfig.collectionViewLayout() }
    var cellRegistration: GifCellRegistration { collectionViewConfig.cellRegistration() }

    func parse(gifs: [GiphyData]) async -> [GifCellViewModel] {
        var result: [GifCellViewModel] = []

        for gif in gifs {
            result.append(
                GifCellViewModel(gif: gif,
                                 isFavorited: await favoriteManager.isFavorite(gif: gif),
                                 delegate: self)
            )
        }

        return result
    }

    @MainActor
    func update(gifs: [GifCellViewModel]) {
        self.gifs = gifs
    }

    @MainActor
    func replace(at index: Int, with gif: GifCellViewModel) {
        gifs[index] = gif
    }

    @MainActor
    func remove(at index: Int) {
        gifs.remove(at: index)
    }

    @MainActor
    func index(of gifId: String) -> Int? {
        gifs.firstIndex { cellViewModel in
            cellViewModel.gif.id == gifId
        }
    }

    @MainActor
    func isEmpty() -> Bool {
        gifs.isEmpty
    }

    private func performFavorited(gif: GiphyData, favorited: Bool) {
        Task {
            favorited ?
            await favoriteManager.addToFavorites(gif: gif) :
            await favoriteManager.removeFromFavorites(gif: gif)

            if let index = await index(of: gif.id) {
                let cellViewModel = await GifCellViewModel(gif: gif,
                                                           isFavorited: favoriteManager.isFavorite(gif: gif),
                                                           delegate: self)

                removeOnUnfavorite ?
                await remove(at: index) :
                await replace(at: index, with: cellViewModel)
            }
        }
    }

    // MARK: - GifCellDelegate conformance
    func performed(gifCellAction: GifCellAction) {
        switch gifCellAction {
            case .favorited(let gif):
                performFavorited(gif: gif, favorited: true)
            case .unfavorited(let gif):
                performFavorited(gif: gif, favorited: false)
        }
    }
}
