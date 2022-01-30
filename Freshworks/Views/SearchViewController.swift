//
//  SearchViewController.swift
//  Freshworks
//
//  Created by Rodrigo Ruiz Murguia on 28/01/22.
//

import Combine
import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let viewModel: SearchViewModel
    private var dataSource: GifDataSource?
    private var cancellables: Set<AnyCancellable> = []

    init?(viewModel: SearchViewModel, coder: NSCoder) {
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
        configureSearchBar()
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
            var snapshot = NSDiffableDataSourceSnapshot<GifSection, GiphyData>()
            snapshot.appendSections([.main])
            snapshot.appendItems(gifs, toSection: .main)

            dataSource?.apply(snapshot)

        }.store(in: &cancellables)
    }

    private func configureSearchBar() {

        NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification,
                                                object: searchBar.searchTextField)
            .compactMap { notification in
                guard
                    let textField = notification.object as? UISearchTextField,
                    let text = textField.text,
                    text.count >= 3 else { return nil }

                return text
            }
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink(receiveValue: { [viewModel] query in
                viewModel.searchEvent(action: .search(query: query))
            })
            .store(in: &cancellables)
    }
}
