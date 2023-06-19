//
//  PodcastSearchController.swift
//  PodCastApp
//
//  Created by MacBook on 18.06.2023.
//

import UIKit
import Alamofire

class PodcastSearchController : UITableViewController, UISearchBarDelegate {
    
    var podcasts = [
        Podcast(trackName: "Lets Build That App", artistName: "Brian Voong"),
        Podcast(trackName: "Some Podcast", artistName: "Some Author")
    ]
    
    let cellId = "PodcastCell"
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setUpTableView()
    }
    
    fileprivate func setupSearchBar(){
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }

    fileprivate func setUpTableView(){
        tableView.register(PodcastCell.self, forCellReuseIdentifier: cellId)
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        APIService.shared.fetchPodcasts(searchText: searchText) { podcastList in
            self.podcasts = podcastList
            self.tableView.reloadData()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? PodcastCell else {
            return UITableViewCell()
        }
        let podcast = self.podcasts[indexPath.row]
        cell.podcast = podcast
        /*
        cell.textLabel?.text = "\(podcast.trackName ?? "")\n\(podcast.artistName ?? "")"
        cell.textLabel?.numberOfLines = -1
        cell.imageView?.image = UIImage(named: "appicon")
         */
        return cell
    }
    
    
}
