//
//  MainTabBarController.swift
//  Yorgan
//
//  Created by Berat Yükselen on 1.05.2025.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        
        let anaSayfaViewController = HomeViewController()
        anaSayfaViewController.tabBarItem = UITabBarItem(title: "Ana Sayfa", image: UIImage(systemName: "house.fill"), tag: 0)
       
        let gelirlerViewController = IncomesViewController()
        gelirlerViewController.tabBarItem = UITabBarItem(title: "Gelirler", image: UIImage(systemName: "plus.circle"), tag: 1)

        let giderlerViewController = ExpensesViewController()
        giderlerViewController.tabBarItem = UITabBarItem(title: "Giderler", image: UIImage(systemName: "minus.circle"), tag: 2)

        let ozetViewController = SummaryViewController()
        ozetViewController.tabBarItem = UITabBarItem(title: "Özet", image:UIImage(systemName: "chart.bar"), tag: 3)
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: "Profil", image: UIImage(systemName: "person.circle"), tag: 4)

        viewControllers = [anaSayfaViewController, gelirlerViewController, ozetViewController, giderlerViewController, profileViewController]
        tabBar.barTintColor = UIColor.systemBackground
        tabBar.tintColor = UIColor.label
        tabBar.unselectedItemTintColor = UIColor.secondaryLabel

    }
}

