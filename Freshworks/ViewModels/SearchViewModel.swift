//
//  SearchViewModel.swift
//  Freshworks
//
//  Created by Rodrigo Ruiz Murguia on 29/01/22.
//

import UIKit

enum SearchControllerAction {
    case firstLoad
    case search(query: String)
    case favorited(gif: GiphyData)
    case unfavorited(gif: GiphyData)
}

protocol SearchViewActionable: AnyObject {
    func searchEvent(action: SearchControllerAction)
}

class SearchViewModel: SearchViewActionable {

    var collectionViewLayout: UICollectionViewLayout { collectionViewConfig.collectionViewLayout() }
    var cellRegistration: GifCellRegistration { collectionViewConfig.cellRegistration() }
    @MainActor @Published var gifs: [GifCellViewModel] = []

    private let collectionViewConfig: GifCollectionViewConfiguration
    private let giphyApi: GiphyApi
    private let favoriteManager: FavoriteManager
    private var currentTask: Task<(), Never>?

    init(collectionViewConfig: GifCollectionViewConfiguration = GifCollectionViewConfiguration(layout: .list),
         giphyApi: GiphyApi = GiphyApiNetwork(),
         favoriteManager: FavoriteManager = FavoriteManager()) {

        self.collectionViewConfig = collectionViewConfig
        self.giphyApi = giphyApi
        self.favoriteManager = favoriteManager
    }

    func searchEvent(action: SearchControllerAction) {
        switch action {
            case .firstLoad:
                firstLoad()
            case .search(let query):
                search(query: query)
            case .favorited(let gif):
                performFavorited(gif: gif, favorited: true)
            case .unfavorited(let gif):
                performFavorited(gif: gif, favorited: false)
        }
    }

    private func parse(gifs: [GiphyData]) -> [GifCellViewModel] {
        gifs.map { gif in
            GifCellViewModel(gif: gif,
                             isFavorited: favoriteManager.isFavorite(gif: gif),
                             delegate: self)
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

    private func performSearch(search: @escaping () async throws -> [GiphyData]) {
        currentTask = Task {
            do {
                let data = try await search()
                let gifs = parse(gifs: data)
                await update(gifs: gifs)
            } catch {
                print(error)
            }
        }
    }

    private func firstLoad() {
        performSearch(search: { [giphyApi] in
            try await giphyApi.trending()
        })
    }

    private func search(query: String) {
        if let currentTask = currentTask {
            currentTask.cancel()
        }

        performSearch(search: { [giphyApi] in
            try await giphyApi.search(query: query)
        })

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
}
