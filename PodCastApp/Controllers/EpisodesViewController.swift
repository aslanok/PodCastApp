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
        //guard let feedUrl = podcast?.feedUrl else { return }
        guard let url = URL(string: podcast?.feedUrl ?? "") else { return }
        let parser = FeedParser(URL: url)
        parser?.parseAsync(result: { result in
            print("successFully parsed : \(result.isSuccess)")
            switch result {
            case let .rss(feed):
                feed.items?.forEach({ feedItem in
                    self.episodes.append(Episode(feedItem: feedItem))
                })
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                break
            case let .failure(error):
                print("Failed to parse feed :", error)
                break
            default:
                print("Found a feed....")
            }
        })
        
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
        //cell.textLabel?.text = episodes[indexPath.row].title
        //cell.textLabel?.numberOfLines = 0
        //cell.textLabel?.text = (episode.title ?? "") + "\n" + (episode.pubDate?.description ?? "")
        return cell
    }

}
