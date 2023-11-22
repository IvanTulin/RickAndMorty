//
//  MainTabBarController.swift
//  NewRickAndMorty
//
//  Created by Ivan Tulin on 18.11.2023.
//

import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabbar()
    }
    
    private func setupTabbar() {
        let episodeTestVC = creatNavController(vc: EpisodeVC(), itemName: "Episode", itemImage: "house.fill")
        let favoritesVC = creatNavController(vc: FavouritesVC(), itemName: "Favourites", itemImage: "heart")
        
        viewControllers = [episodeTestVC,favoritesVC]
    }

    private func creatNavController(vc: UIViewController, itemName: String, itemImage: String) -> UINavigationController {
        let item = UITabBarItem(title: itemName, image: UIImage(systemName: itemImage)?.withAlignmentRectInsets(.init(top: 10, left: 0, bottom: 0, right: 0)), tag: 0)//выравнивание изображение
        item.titlePositionAdjustment = .init(horizontal: 0, vertical: 10)//отспуы для titleText
        
        let navController =  UINavigationController(rootViewController: vc)
        navController.tabBarItem = item
        
        return navController
    }
}
