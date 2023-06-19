//
//  SearchResults.swift
//  PodCastApp
//
//  Created by MacBook on 18.06.2023.
//

import Foundation

struct SearchResults : Decodable {
    let resultCount : Int
    let results : [Podcast]
    
}
