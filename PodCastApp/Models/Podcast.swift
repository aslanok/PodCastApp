//
//  Podcast.swift
//  PodCastApp
//
//  Created by MacBook on 18.06.2023.
//

import Foundation

struct Podcast : Decodable {
    let trackName : String?
    let artistName : String?
    let artworkUrl60 : String?
    var trackCount : Int?
    var feedUrl : String?
}
