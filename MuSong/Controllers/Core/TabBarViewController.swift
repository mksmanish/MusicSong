//
//  TabBarViewController.swift
//  MuSong
//
//  Created by Tradesocio on 26/05/22.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewcntroller1 = HomeViewController()
        let viewcntroller2 = SearchViewController()
        let viewcntroller3 = LibraryViewController()
        
        viewcntroller1.title = "Browse"
        viewcntroller2.title = "Search"
        viewcntroller3.title = "Library"
        
        viewcntroller1.navigationItem.largeTitleDisplayMode = .always
        viewcntroller2.navigationItem.largeTitleDisplayMode = .always
        viewcntroller3.navigationItem.largeTitleDisplayMode = .always
        
        let navigation1 = UINavigationController(rootViewController: viewcntroller1)
        let navigation2 = UINavigationController(rootViewController: viewcntroller2)
        let navigation3 = UINavigationController(rootViewController: viewcntroller3)
        
        navigation1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        navigation2.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 2)
        navigation3.tabBarItem = UITabBarItem(title: "Library", image: UIImage(systemName: "music.note.list"), tag: 3)
        
        navigation1.navigationBar.prefersLargeTitles  = true
        navigation2.navigationBar.prefersLargeTitles  = true
        navigation3.navigationBar.prefersLargeTitles  = true
        
     
        
        setViewControllers([navigation1,navigation2,navigation3], animated: true)
        
        
        
    }
    
}
