//
//  SearchCell.swift
//  Freshworks
//
//  Created by Rodrigo Ruiz Murguia on 28/01/22.
//

import UIKit
import WebKit

class GifCell: UICollectionViewCell, WKNavigationDelegate {

    static let name = String(describing: GifCell.self)

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    private var viewModel: GifCellViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(viewModel: GifCellViewModel) {
        guard let webView = webView else { return }

        self.viewModel = viewModel
        webView.navigationDelegate = self

        if let request = viewModel.request,
           let url = request.url {

            if url.isFileURL,
               let data = try? Data(contentsOf: url) {
                webView.load(data, mimeType: "image/gif", characterEncodingName: "base64", baseURL: url)
            } else {
                webView.load(request)
            }

        }
        
        favoriteButton.configuration?.background.image = viewModel.backgroundImage
    }

    @IBAction func favoriteButtonTapped(_ sender: Any) {
        viewModel?.favoritedToggled()
        let workingImage = UIImage(systemName: "opticaldisc")?
            .withRenderingMode(.alwaysOriginal)
        favoriteButton.configuration?.background.image = workingImage
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
