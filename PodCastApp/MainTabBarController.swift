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
    var bottomAnchorConstraint : NSLayoutConstraint!
    
    fileprivate func setUpPlayerDetailsView(){
        view.insertSubview(playerDetailView, belowSubview: tabBar)
        
        playerDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        maximizedTopAnchorConstraint = playerDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        maximizedTopAnchorConstraint.isActive = true
        
        minimizedTopAnchorConstraint = playerDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        //minimizedTopAnchorConstraint.isActive = true
        playerDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        bottomAnchorConstraint = playerDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAnchorConstraint.isActive = true
    }
    
    func minimizePlayerDetails() {
        maximizedTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimizedTopAnchorConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.transform = .identity
            self.playerDetailView.contentView.alpha = 0
            self.playerDetailView.minimizeContentView.alpha = 1
        })
    }
    
    func maximizePlayerDetails(episode : Episode?, playlistEpisodes : [Episode] = [] ) {
        minimizedTopAnchorConstraint.isActive = false
        maximizedTopAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.constant = 0
        
        bottomAnchorConstraint.constant = 0
        
        playerDetailView.playlistEpisodes = playlistEpisodes
        
        if episode != nil {
            playerDetailView.episode = episode
        }

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            self.playerDetailView.contentView.alpha = 1
            self.playerDetailView.minimizeContentView.alpha = 0
        })
    }
    
    func setUpViewControllers(){
        let layout = UICollectionViewFlowLayout()
        let favoritesController = FavoritesController(collectionViewLayout: layout)
        
        viewControllers = [
            generateNavigationController(with: "Favorites", and: UIImage(named: "favorites"), vc: favoritesController),
            generateNavigationController(with: "Search", and: UIImage(named: "search"), vc: PodcastSearchController()),
            generateNavigationController(with: "Downloads", and: UIImage(named: "downloads"), vc: DownloadController())
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
