//
//  UIApplication.swift
//  PodCastApp
//
//  Created by MacBook on 28.06.2023.
//

import UIKit

extension UIApplication{
    static func mainTabBarController() -> MainTabBarController? {
        return shared.keyWindow?.rootViewController as? MainTabBarController
    }
    
}
