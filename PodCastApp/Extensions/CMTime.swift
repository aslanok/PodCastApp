//
//  CMTime.swift
//  PodCastApp
//
//  Created by MacBook on 23.06.2023.
//

import AVKit

extension CMTime{
    func toDisplayString()-> String {
        if CMTimeGetSeconds(self).isNaN {
            return "--:--"
        }
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minutes = totalSeconds / 60
        let timeFormatString = String(format: "%02d:%02d", minutes,seconds)
        return timeFormatString
    }
}
