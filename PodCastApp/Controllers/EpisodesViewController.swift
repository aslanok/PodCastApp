//
//  EpisodesViewController.swift
//  PodCastApp
//
//  Created by MacBook on 20.06.2023.
//

import UIKit
import FeedKit

class EpisodesViewController: UITableViewController {
    
    var podcast : Podcast?{
        didSet{
            navigationItem.title = podcast?.trackName
            fetchEpisodes()
        }
    }
    
    fileprivate let cellId = "episodeCellId"
    var episodes = [Episode]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    fileprivate func fetchEpisodes(){
        guard let feedUrl = podcast?.feedUrl else { return }
        //guard let url = URL(string: podcast?.feedUrl ?? "") else { return }
        APIService.shared.fetchEpisodes(feedUrl: feedUrl) { episodes in
            self.episodes = episodes
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    fileprivate func setUpTableView(){
        tableView.register(EpisodeCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? EpisodeCell else {
            return UITableViewCell()
        }
        let episode = episodes[indexPath.row]
        cell.setUp(episode: episode)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = self.episodes[indexPath.row]
        let window = UIApplication.shared.keyWindow
        let redView = UIView()
        redView.backgroundColor = .red
        redView.frame = self.view.frame
        window?.addSubview(redView)
        
    }
    

}
