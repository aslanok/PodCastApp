//
//  String.swift
//  PodCastApp
//
//  Created by MacBook on 21.06.2023.
//

import Foundation

extension String {
    func toSecureHTTPS()-> String{
        return self.contains("https") ? self : self.replacingOccurrences(of: "http", with: "https")
    }
    
}
