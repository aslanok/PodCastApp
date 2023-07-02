//
//  EpisodesViewController.swift
//  PodCastApp
//
//  Created by MacBook on 20.06.2023.
//

import UIKit
import FeedKit

class EpisodesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var podcast : Podcast?{
        didSet{
            navigationItem.title = podcast?.trackName
            fetchEpisodes()
        }
    }
    
    private lazy var episodeTableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    fileprivate let cellId = "episodeCellId"
    var episodes = [Episode]()

    override func viewDidLoad() {
        super.viewDidLoad()
        episodeTableView.delegate = self
        episodeTableView.dataSource = self
        setUpTableView()
        setupNavigationBarButtons()
    }
    
    fileprivate func setupNavigationBarButtons(){
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(handleSaveFavorite)),
            UIBarButtonItem(title: "Fetch", style: .plain, target: self, action: #selector(handleFetchSavedPodcasts))
        ]
    }
    
    @objc fileprivate func handleFetchSavedPodcasts(){
        
        let value = UserDefaults.standard.value(forKey: favoritedPodcastKey) as? String
        //print(value ?? "bos")
        guard let data = UserDefaults.standard.data(forKey: favoritedPodcastKey) else { return }
        guard let podcast = NSKeyedUnarchiver.unarchiveObject(with: data) as? Podcast else { return }
        print("podcastName : \(podcast.trackName), \(podcast.artistName)")
        
        
    }
    
    let favoritedPodcastKey = "favoritedPodcastKey"
    
    @objc fileprivate func handleSaveFavorite(){
        print("saving info into userDefaults")
        
        guard let podcast = self.podcast else { return }
        
        let data = NSKeyedArchiver.archivedData(withRootObject: podcast)
        
        
        UserDefaults.standard.set(data, forKey: favoritedPodcastKey)
        
    }
    
    fileprivate func fetchEpisodes(){
        guard let feedUrl = podcast?.feedUrl else { return }
        //guard let url = URL(string: podcast?.feedUrl ?? "") else { return }
        APIService.shared.fetchEpisodes(feedUrl: feedUrl) { episodes in
            self.episodes = episodes
            DispatchQueue.main.async {
                self.episodeTableView.reloadData()
            }
        }
    }
    
    fileprivate func setUpTableView(){
        view.addSubview(episodeTableView)
        episodeTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        episodeTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        episodeTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        episodeTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        episodeTableView.register(EpisodeCell.self, forCellReuseIdentifier: cellId)
        episodeTableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activitiyIndicatorView = UIActivityIndicatorView(style: .large)
        activitiyIndicatorView.color = .darkGray
        activitiyIndicatorView.startAnimating()
        return activitiyIndicatorView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return episodes.isEmpty ? 200 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? EpisodeCell else {
            return UITableViewCell()
        }
        let episode = episodes[indexPath.row]
        cell.setUp(episode: episode)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = self.episodes[indexPath.row]
        let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
        mainTabBarController?.maximizePlayerDetails(episode: episode, playlistEpisodes : self.episodes)
        
    }
    

}
