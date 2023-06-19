//
//  APIService.swift
//  PodCastApp
//
//  Created by MacBook on 19.06.2023.
//

import Foundation
import Alamofire

class APIService {
    
    let baseiTunesSearchURL = "https://itunes.apple.com/search"

    
    static let shared = APIService()
    
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
