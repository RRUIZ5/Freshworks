//
//  TabBarElement.swift
//  Freshworks
//
//  Created by Rodrigo Ruiz Murguia on 27/01/22.
//

import UIKit

extension MainTabBarController {

    enum TabBarElement: Int {
        case search = 0
        case favorites

        var title: String? {
            switch self {
                case .search:
//                    return NSLocalizedString("TabBar-Search", comment: "First tab bar item from main screen")
                    return nil
                case .favorites:
//                    return NSLocalizedString("TabBar-Favorites", comment: "Second tab bar item from main screen")
                    return nil
            }
        }

        var image: UIImage? {
            switch self {
                case .search:
                    return UIImage(systemName: "photo.on.rectangle")
                case .favorites:
                    return UIImage(systemName: "heart.fill")
            }
        }
    }
}
