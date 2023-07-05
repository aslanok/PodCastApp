//
//  Episode.swift
//  PodCastApp
//
//  Created by MacBook on 20.06.2023.
//

import Foundation
import FeedKit

struct Episode : Encodable, Decodable {
    let title : String?
    let pubDate : Date?
    let description : String?
    var imageUrl : String?
    let author : String
    let streamUrl : String
    
    var fileUrl : String?

    init(feedItem : RSSFeedItem) {
        self.streamUrl = feedItem.enclosure?.attributes?.url ?? ""
        self.title = feedItem.title ?? ""
        self.pubDate = feedItem.pubDate ?? Date()
        self.description = feedItem.iTunes?.iTunesSubtitle ?? feedItem.description ?? ""
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
        self.author = feedItem.iTunes?.iTunesAuthor ?? ""
    }
    
}
