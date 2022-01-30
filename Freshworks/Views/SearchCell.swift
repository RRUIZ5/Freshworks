//
//  SearchCell.swift
//  Freshworks
//
//  Created by Rodrigo Ruiz Murguia on 28/01/22.
//

import UIKit
import WebKit

class SearchCell: UICollectionViewCell, WKNavigationDelegate {

    static let name = String(describing: SearchCell.self)

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    private var favorited = false

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(url: URL) {
        guard let webView = webView else { return }
        webView.navigationDelegate = self

        let request = URLRequest(url: url)
        webView.load(request)
    }

    @IBAction func favoriteButtonTapped(_ sender: Any) {
        favorited.toggle()
        let symbolName = favorited ? "heart.fill" : "heart"
        let image = UIImage(systemName: symbolName)?.withRenderingMode(.alwaysOriginal)
        favoriteButton.configuration?.background.image = image
    }

    override func prepareForReuse() {
        webView.isHidden = true
        loadingView.isHidden = false
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.isHidden = false
        loadingView.isHidden = true
    }

}
