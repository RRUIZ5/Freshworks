//
//  FavoritesViewController.swift
//  Freshworks
//
//  Created by Rodrigo Ruiz Murguia on 29/01/22.
//

import Combine
import UIKit

class FavoritesViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!

    private let viewModel: FavoritesViewModel
    private var dataSource: GifDataSource?
    private var cancellables: Set<AnyCancellable> = []

    init?(viewModel: FavoritesViewModel, coder: NSCoder) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    @available(*, unavailable, renamed: "init(viewModel:coder:)")
    required init?(coder: NSCoder) {
        fatalError("Invalid way of decoding this class")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureViewModel()
        configureLayoutPublisher()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.searchEvent(action: .firstLoad)
    }

    private func configureCollectionView() {

        let layout = viewModel.collectionViewLayout
        collectionView.setCollectionViewLayout(layout, animated: true)
        let cellRegistration = viewModel.cellRegistration

        dataSource = GifDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, giphyData in
                collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: giphyData)
            }
        )
    }

    private func configureViewModel() {
        viewModel.$gifs.sink { [dataSource] gifs in
            var snapshot = GifSnapshot()
            snapshot.appendSections([.main])
            snapshot.appendItems(gifs, toSection: .main)

            dataSource?.apply(snapshot)

        }.store(in: &cancellables)
    }

    private func configureLayoutPublisher() {
        viewModel.$collectionViewConfig
            .sink { [collectionView] config in
                collectionView?.setCollectionViewLayout(config.collectionViewLayout(), animated: true)
            }.store(in: &cancellables)
    }

    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        if let segmentIndex = FavoritedSelectedIndex(rawValue: sender.selectedSegmentIndex) {
            switch segmentIndex {
                case .grid:
                    viewModel.searchEvent(action: .grid)
                case .list:
                    viewModel.searchEvent(action: .list)
            }
        }
    }
}
