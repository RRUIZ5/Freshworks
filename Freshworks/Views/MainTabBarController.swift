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
              items.count >= TabBarElement.allCases.count else {
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
}
