//
//  Episode.swift
//  PodCastApp
//
//  Created by MacBook on 20.06.2023.
//

import Foundation
import FeedKit

struct Episode {
    let title : String?
    let pubDate : Date?
    let description : String?
    
    init(feedItem : RSSFeedItem) {
        self.title = feedItem.title ?? ""
        self.pubDate = feedItem.pubDate ?? Date()
        self.description = feedItem.description ?? ""
    }
    
}
