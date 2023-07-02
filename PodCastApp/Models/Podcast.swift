//
//  Podcast.swift
//  PodCastApp
//
//  Created by MacBook on 18.06.2023.
//

import Foundation

class Podcast : NSObject, Decodable, NSCoding {
    func encode(with coder: NSCoder) {
        print("trying to transform Podcast into Data")
        coder.encode(trackName ?? "", forKey: "trackNameKey")
        coder.encode(artistName ?? "", forKey: "artistNameKey")
        coder.encode(artworkUrl60 ?? "", forKey: "artworkKey")

    }
    
    required init?(coder: NSCoder) {
        print("trying to turn data into podcast")
        self.trackName = coder.decodeObject(forKey: "trackNameKey") as? String
        self.artistName = coder.decodeObject(forKey: "artistNameKey") as? String
        self.artworkUrl60 = coder.decodeObject(forKey: "artworkKey") as? String
    }
    
    let trackName : String?
    let artistName : String?
    let artworkUrl60 : String?
    var trackCount : Int?
    var feedUrl : String?
}
