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
            print("podCast : \(podcast?.feedUrl)")
        }
    }
    
    fileprivate let cellId = "cellId"
    var episodes = [
        Episode(title: "ep1"),
        Episode(title: "ep2"),
        Episode(title: "ep3")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    fileprivate func fetchEpisodes(){
        
    }
    
    fileprivate func setUpTableView(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = episodes[indexPath.row].title
        return cell
    }

}
