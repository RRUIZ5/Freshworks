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

class SearchViewModel {

    var collectionViewLayout: UICollectionViewLayout { collectionViewConfig.collectionViewLayout() }
    var cellRegistration: GifCellRegistration { collectionViewConfig.cellRegistration() }
    @MainActor @Published var gifs: [GiphyData] = []

    private let collectionViewConfig: GifCollectionViewConfiguration
    private let giphyApi: GiphyApi
    private var currentTask: Task<(), Never>?

    init(collectionViewConfig: GifCollectionViewConfiguration = GifCollectionViewConfiguration(layout: .list),
         giphyApi: GiphyApi = GiphyApiNetwork()) {

        self.collectionViewConfig = collectionViewConfig
        self.giphyApi = giphyApi
    }

    func searchEvent(action: SearchControllerAction) {
        switch action {
            case .firstLoad:
                firstLoad()
            case .search(let query):
                search(query: query)
            case .favorited(let gif):
                print("User favorited", gif.title)
            case .unfavorited(let gif):
                print("User unfavorited", gif.title)

        }
    }

    func firstLoad() {
        currentTask = Task {
            do {
                let gifs = try await giphyApi.trending()
                await MainActor.run { self.gifs = gifs }
            } catch {
                print(error)
            }
        }
    }

    func search(query: String) {
        if let currentTask = currentTask {
            currentTask.cancel()
        }

        currentTask = Task {
            do {
                let gifs = try await giphyApi.search(query: query)
                await MainActor.run { self.gifs = gifs }
            } catch {
                print(error)
            }
        }
    }
}
