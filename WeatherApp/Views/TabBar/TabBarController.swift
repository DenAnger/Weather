//
//  TabBarController.swift
//  WeatherApp
//
//  Created by Denis Abramov on 04.12.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setupTabBar()
    }
    
    func setupTabBar() {
        let weatherViewController = WeatherViewController()
        let mapViewController = MapViewController()
        
        weatherViewController.tabBarItem.image = UIImage(systemName: "umbrella")
        mapViewController.tabBarItem.image = UIImage(systemName: "map")
        weatherViewController.tabBarItem.title = "Weather"
        mapViewController.tabBarItem.title = "Map"
        
        viewControllers = [weatherViewController, mapViewController]
        
        weatherViewController.tabBarHeight = tabBar.bounds.height
        tabBar.backgroundColor = .systemBackground
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let weatherViewController = viewController as? WeatherViewController {
            weatherViewController.addCityFromMap()
        }
    }
}
