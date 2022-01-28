//
//  SearchViewController.swift
//  Freshworks
//
//  Created by Rodrigo Ruiz Murguia on 28/01/22.
//

import UIKit
import WebKit

class SearchViewController: UIViewController {

    @IBOutlet weak var webView1: WKWebView!
    @IBOutlet weak var webView2: WKWebView!
    @IBOutlet weak var webView3: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let api = GiphyApiNetwork()
        Task {
            do {
                let response = try await api.trending()
                let x = zip(response.data.prefix(3),
                            [webView1, webView2, webView3])

                x.forEach { (data, webView) in
                    let url = URL(string: data.images.fixedWidth.url)!
                    print(url)
                    let request = URLRequest(url: url)
                    webView?.load(request)
                }

            } catch {
                print(error)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
