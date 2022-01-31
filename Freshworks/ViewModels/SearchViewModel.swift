//
//  SearchViewModel.swift
//  Freshworks
//
//  Created by Rodrigo Ruiz Murguia on 29/01/22.
//

import UIKit

class SearchViewModel: GifViewModel {
    
    @MainActor @Published var gifs: [GifCellViewModel] = []

    let collectionViewConfig: GifCollectionViewConfiguration
    let favoriteManager: FavoriteManager
    let removeOnUnfavorite = false
    private let giphyApi: GiphyApi
    private var currentTask: Task<(), Never>?

    init(collectionViewConfig: GifCollectionViewConfiguration = GifCollectionViewConfiguration(layout: .list),
         giphyApi: GiphyApi = GiphyApiNetwork(),
         favoriteManager: FavoriteManager = DiskFavoriteManager(networkManager: NetworkManager())) {

        self.collectionViewConfig = collectionViewConfig
        self.giphyApi = giphyApi
        self.favoriteManager = favoriteManager
    }

    @MainActor
    func searchEvent(action: SearchControllerAction) {
        switch action {
            case .firstLoad:
                firstLoad()
            case .search(let query):
                search(query: query)
        }
    }

    private func performSearch(search: @escaping () async throws -> [GiphyData]) {
        currentTask = Task {
            do {
                let data = try await search()
                let gifs = await parse(gifs: data)
                await update(gifs: gifs)
            } catch {
                print(error)
            }
        }
    }

    private func firstLoad() {
        Task {
            guard await isEmpty() else { return }

            performSearch(search: { [giphyApi] in
                try await giphyApi.trending()
            })
        }
    }

    private func search(query: String) {
        if let currentTask = currentTask {
            currentTask.cancel()
        }

        performSearch(search: { [giphyApi] in
            try await giphyApi.search(query: query)
        })

    }
}
