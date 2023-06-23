//
//  MainTabBarController.swift
//  PodCastApp
//
//  Created by MacBook on 17.06.2023.
//

import UIKit

class MainTabBarController : UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .purple
        //tabBar.backgroundColor = .lightGray
        UINavigationBar.appearance().prefersLargeTitles = true
        
        setUpViewControllers()
        
        setUpPlayerDetailsView()
    }
    
    fileprivate func setUpPlayerDetailsView(){
        print("setting up playerDetailsView")
        let playerDetailView = PlayerDetailView()
        playerDetailView.backgroundColor = .red
        
        //view.addSubview(playerDetailView)
        view.insertSubview(playerDetailView, belowSubview: tabBar)
        
        playerDetailView.translatesAutoresizingMaskIntoConstraints = false
        playerDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64).isActive = true
        playerDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        playerDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
        
    }
    
    func setUpViewControllers(){
        viewControllers = [
            generateNavigationController(with: "Search", and: UIImage(named: "search"), vc: PodcastSearchController()),
            generateNavigationController(with: "Favorites", and: UIImage(named: "favorites"), vc: ViewController()),
            generateNavigationController(with: "Downloads", and: UIImage(named: "downloads"), vc: ViewController())
        ]
    }
    
    private func generateNavigationController(with title : String, and image : UIImage?, vc : UIViewController) -> UIViewController {
        let nav = UINavigationController(rootViewController: vc)
        //nav.navigationBar.prefersLargeTitles = true //UINavigationBar.appearance().prefersLargeTitles = true
        //nav.navigationBar.backgroundColor = .lightGray //that works
        vc.navigationItem.title = title
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        return nav
    }
    
    
}
