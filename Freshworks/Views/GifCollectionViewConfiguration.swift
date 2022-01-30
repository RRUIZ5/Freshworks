//
//  GifCollectionViewConfiguration.swift
//  Freshworks
//
//  Created by Rodrigo Ruiz Murguia on 29/01/22.
//

import UIKit

typealias GifCellRegistration = UICollectionView.CellRegistration<SearchCell, GiphyData>
typealias GifDataSource = UICollectionViewDiffableDataSource<GifSection, GiphyData>

class GifCollectionViewConfiguration {

    let layout: GifCollectionViewLayout

    init(layout: GifCollectionViewLayout) {
        self.layout = layout
    }

    func cellRegistration() -> GifCellRegistration {
        let nib = UINib(nibName: SearchCell.name, bundle: .main)

        return GifCellRegistration(cellNib: nib) {
            cell, indexPath, giphyData in

            if let url = URL(string: giphyData.images.fixedHeight.url) {
                cell.configure(url: url)
            }
        }
    }

    func collectionViewLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout {
            [weak self] sectionIndex, _ in

            guard let self = self,
                  let section = GifSection(rawValue: sectionIndex) else {
                      return nil
                  }

            switch section {
                case .main:
                    return self.selectedLayout()
            }
        }
    }

    private func listLayoutSection() -> NSCollectionLayoutSection {

        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        ))
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(200)
            ),
            subitems: [item]
        )

        return NSCollectionLayoutSection(group: group)
    }

    private func gridLayoutSection() -> NSCollectionLayoutSection {

        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.32),
            heightDimension: .fractionalHeight(1)
        ))

        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(150)
            ),
            subitem: item,
            count: 3
        )

        return NSCollectionLayoutSection(group: group)
    }

    private func selectedLayout() -> NSCollectionLayoutSection {
        switch layout {
            case .list:
                return listLayoutSection()
            case .grid:
                return gridLayoutSection()
        }
    }
}
