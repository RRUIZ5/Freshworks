//
//  SearchViewController.swift
//  Freshworks
//
//  Created by Rodrigo Ruiz Murguia on 28/01/22.
//

import UIKit
import WebKit

class SearchViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    let config = GifCollectionViewConfiguration(layout: .list)

    private var dataSource: UICollectionViewDiffableDataSource<GifSection, GiphyData>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }

    private func configureCollectionView() {

        let layout = config.collectionViewLayout()
        collectionView.setCollectionViewLayout(layout, animated: true)
        let cellRegistration = config.cellRegistration()

        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, giphyData in
                collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: giphyData)
            }
        )

        Task {
            do {
                let api = GiphyApiNetwork()
                let data1 = try await api.trending().data
                let data = Array(Set(data1))
                var snapshot = NSDiffableDataSourceSnapshot<GifSection, GiphyData>()
                snapshot.appendSections([.main])
                snapshot.appendItems(data, toSection: .main)

                await dataSource?.apply(snapshot, animatingDifferences: true)

            } catch {
                print(error)
            }
        }
    }
}
