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
        tabBar.backgroundColor = .white
        //tabBar.backgroundColor = .lightGray
        UINavigationBar.appearance().prefersLargeTitles = true
        
        setUpViewControllers()
        
        setUpPlayerDetailsView()
        //perform(#selector(maximizePlayerDetails), with: nil, afterDelay: 1)
    }
    
    let playerDetailView = PlayerDetailView()

    var maximizedTopAnchorConstraint : NSLayoutConstraint!
    var minimizedTopAnchorConstraint : NSLayoutConstraint!
    
    fileprivate func setUpPlayerDetailsView(){
        print("setting up playerDetailsView")
        
        view.insertSubview(playerDetailView, belowSubview: tabBar)
        
        playerDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        maximizedTopAnchorConstraint = playerDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        //maximizedTopAnchorConstraint.isActive = true
        
        minimizedTopAnchorConstraint = playerDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        //minimizedTopAnchorConstraint.isActive = true
        playerDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        playerDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
    
    func minimizePlayerDetails() {
        maximizedTopAnchorConstraint.isActive = false
        minimizedTopAnchorConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.transform = .identity
            self.playerDetailView.contentView.isHidden = true
            self.playerDetailView.minimizeContentView.isHidden = false
        })
    }
    
    func maximizePlayerDetails(episode : Episode?) {
        maximizedTopAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.constant = 0
        minimizedTopAnchorConstraint.isActive = false
        
        if episode != nil {
            playerDetailView.episode = episode
        }

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.transform = CGAffineTransform(scaleX: 0, y: 100)
            self.playerDetailView.contentView.isHidden = false
            self.playerDetailView.minimizeContentView.isHidden = true
        })
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
