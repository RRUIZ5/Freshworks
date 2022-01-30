//
//  GifCellViewModel.swift
//  Freshworks
//
//  Created by Rodrigo Ruiz Murguia on 29/01/22.
//

import Foundation
import UIKit

class GifCellViewModel: Hashable {

    var request: URLRequest? { createRequest() }
    var backgroundImage: UIImage? { createImage() }

    let gif: GiphyData
    private let isFavorited: Bool
    private weak var delegate: SearchViewActionable?

    init(gif: GiphyData, isFavorited: Bool, delegate: SearchViewActionable) {
        self.gif = gif
        self.isFavorited = isFavorited
        self.delegate = delegate
    }

    func favoritedToggled() {
        let action: SearchControllerAction = isFavorited ?
            .unfavorited(gif: gif) :
            .favorited(gif: gif)

        delegate?.searchEvent(action: action)
    }

    private func createRequest() -> URLRequest? {
        guard let url = URL(string: gif.images.fixedHeight.url) else {
            return nil
        }

        return URLRequest(url: url)
    }

    private func createImage() -> UIImage? {
        let symbolName = isFavorited ? "heart.fill" : "heart"
        return UIImage(systemName: symbolName)?.withRenderingMode(.alwaysOriginal)
    }
    
    static func == (lhs: GifCellViewModel, rhs: GifCellViewModel) -> Bool {
        lhs.gif.id == rhs.gif.id
    }

    func hash(into: inout Hasher) {
        into.combine(gif.id)
    }
}
