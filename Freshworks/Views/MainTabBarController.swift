//
//  MainTabBarController.swift
//  Freshworks
//
//  Created by Rodrigo Ruiz Murguia on 27/01/22.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTabBar()
    }

    private func setUpTabBar() {
        guard let items = tabBar.items,
        items.count >= 2 else {
            assert(false, "Bad storyboard set up, expecting at least 2 items")
            return
        }

        items.enumerated().forEach { index, item in

            guard let element = TabBarElement(rawValue: index) else {
                assert(false, "Bad storyboard set up, expecting at least 2 items")
                return
            }

            item.title = element.title
            item.image = element.image
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let api = GiphyApiNetwork()
        Task {
            do {
            let response = try await api.search(query: "Zeratul")
                response.data.forEach { data in
                    print(data.images.original.webp)
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
