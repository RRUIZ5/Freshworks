//
//  SearchCell.swift
//  Freshworks
//
//  Created by Rodrigo Ruiz Murguia on 28/01/22.
//

import UIKit
import WebKit

class SearchCell: UICollectionViewCell {

    static let name = String(describing: SearchCell.self)

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var favoriteButton: UIButton!
    private var favorited = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(url: URL) {
        let request = URLRequest(url: url)
        webView?.load(request)
    }

    @IBAction func favoriteButtonTapped(_ sender: Any) {
        favorited.toggle()
        let symbolName = favorited ? "heart.fill" : "heart"
        let image = UIImage(systemName: symbolName)?.withRenderingMode(.alwaysOriginal)
        favoriteButton.configuration?.background.image = image
    }
}
