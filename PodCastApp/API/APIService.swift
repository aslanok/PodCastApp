//
//  APIService.swift
//  PodCastApp
//
//  Created by MacBook on 19.06.2023.
//

import Foundation
import Alamofire
import FeedKit

class APIService {
    
    let baseiTunesSearchURL = "https://itunes.apple.com/search"

    
    static let shared = APIService()
    
    func fetchEpisodes(feedUrl : String, completionHandler : @escaping ([Episode]) -> ()){
        
        let secureFeedUrl = feedUrl.contains("https") ? feedUrl : feedUrl.replacingOccurrences(of: "http", with: "https")
        guard let url = URL(string: secureFeedUrl) else { return }
        let parser = FeedParser(URL: url)
        parser?.parseAsync(result: { result in
            if let err = result.error {
                print("Failed to parse XML Feed:",err)
                return
            }
            guard let feed = result.rssFeed else { return }
            completionHandler(feed.toEpisodes())
            
            /*
            self.episodes = feed.toEpisodes()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
             */
        })
        
    }
    
    
    func fetchPodcasts(searchText : String, completionHandler : @escaping ([Podcast]) -> ()){
        //let url = "https://itunes.apple.com/search?term=\(searchText)"
        let parameters = ["term":searchText, "media": "podcast"]
        Alamofire.request(baseiTunesSearchURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { dataResponse in
            if let err = dataResponse.error {
                print("failed to contact to yahoo : \(err)")
                return
            }
            
            guard let data = dataResponse.data else { return }
            do {
                let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
                print("search Result : \(searchResult.resultCount)")
                completionHandler(searchResult.results)
                //self.podcasts = searchResult.results
                //self.tableView.reloadData()
            } catch let decodeErr {
                print("failed to decode ", decodeErr)
            }
        }
    }
    
}
