//
//  RootViewController.swift
//  Freshworks
//
//  Created by Rodrigo Ruiz Murguia on 29/01/22.
//

import Foundation
import UIKit

class RootViewController: UIViewController {

    let favoriteManager = FavoriteManager()

    @IBSegueAction func createSearchController(_ coder: NSCoder) -> SearchViewController? {
        let viewModel = SearchViewModel(favoriteManager: favoriteManager)
        return SearchViewController(viewModel: viewModel, coder: coder)
    }

    @IBSegueAction func createFavoritesController(_ coder: NSCoder) -> FavoritesViewController? {
        let viewModel = FavoritesViewModel(favoriteManager: favoriteManager)
        return FavoritesViewController(viewModel: viewModel, coder: coder)
    }
}
