//
//  APIService.swift
//  PodCastApp
//
//  Created by MacBook on 19.06.2023.
//

import Foundation
import Alamofire
import FeedKit

extension NSNotification.Name{
    static let downloadProgress = NSNotification.Name("downloadProgress")
    static let downloadComplete = NSNotification.Name("downloadComplete")
}

class APIService {
    
    typealias EpisodeDownloadCompleteTuple = (fileUrl : String, episodeTitle : String)
    
    let baseiTunesSearchURL = "https://itunes.apple.com/search"

    static let shared = APIService()
    
    func downloadEpisode(episode : Episode){
        let downloadRequest = DownloadRequest.suggestedDownloadDestination()
        Alamofire.download(episode.streamUrl, to: downloadRequest).downloadProgress { progress in
            NotificationCenter.default.post(name: .downloadProgress, object: nil, userInfo: ["title" : episode.title  ?? "", "progress" : progress.fractionCompleted ])
        }.response { resp in
            let episodeDownloadComplete = EpisodeDownloadCompleteTuple(fileUrl : resp.destinationURL?.absoluteString ?? "", episode.title ?? "")
            NotificationCenter.default.post(name: .downloadComplete, object: episodeDownloadComplete)
            
            var downloadedEpisodes = UserDefaults.standard.downloadedEpisodes()
            guard let index = downloadedEpisodes.firstIndex(where: { $0.title == episode.title && $0.author == episode.author }) else { return }
            downloadedEpisodes[index].fileUrl = resp.destinationURL?.absoluteString ?? ""
            do{
                let data = try JSONEncoder().encode(downloadedEpisodes)
                UserDefaults.standard.set(data, forKey: UserDefaults.downloadEpisodesKey)
            } catch let err {
                print("failed to encode downloaded episodes with file url update :\(err)")
            }
        }
    }
    
    
    func fetchEpisodes(feedUrl : String, completionHandler : @escaping ([Episode]) -> ()){
        
        let secureFeedUrl = feedUrl.contains("https") ? feedUrl : feedUrl.replacingOccurrences(of: "http", with: "https")
        guard let url = URL(string: secureFeedUrl) else { return }
        
        // alttaki satır şu işe yarıyor : sayfaya tıklayınca sayfaya gidiyoruz ama veriler daha sonradan geliyor.
        // bunu yazmasaydık sayfaya geçiş işlemimiz de yavaş oluyordu
        DispatchQueue.global(qos: .background).async {
            let parser = FeedParser(URL: url)
            parser?.parseAsync(result: { result in
                if let err = result.error {
                    print("Failed to parse XML Feed:",err)
                    return
                }
                guard let feed = result.rssFeed else { return }
                completionHandler(feed.toEpisodes())
            })
        }
        
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
