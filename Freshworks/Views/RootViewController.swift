//
//  RootViewController.swift
//  Freshworks
//
//  Created by Rodrigo Ruiz Murguia on 29/01/22.
//

import Foundation
import UIKit

class RootViewController: UIViewController {

    @IBSegueAction func createSearchController(_ coder: NSCoder) -> SearchViewController? {
        let searchViewModel = SearchViewModel(collectionViewConfig: GifCollectionViewConfiguration(layout: .list))
        return SearchViewController(viewModel: searchViewModel, coder: coder)
    }
}
