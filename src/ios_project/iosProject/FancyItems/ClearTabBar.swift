//
//  ClearTabBarController.swift
//  iosProject
//
//  Created by Patunique on 17.03.2020.
//  Copyright © 2020 Patunique. All rights reserved.
//

import UIKit

class ClearTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let arrayOfImageNameForSelectedState = [
            "ShopImage", "TableImage", "QuestImage", "SettingsImage", "ProfileImage"]
        let arrayOfImageNameForUnselectedState = [
            "ShopImageOff", "TableImageOff", "QuestImageOff", "SettingsImageOff", "ProfileImageOff"]
        if let count = self.tabBar.items?.count {
            for i in 0...(count - 1) {
                let imageNameForSelectedState   = arrayOfImageNameForSelectedState[i]
                let imageNameForUnselectedState = arrayOfImageNameForUnselectedState[i]
                
                self.tabBar.items?[i].selectedImage = UIImage(named: imageNameForSelectedState)?.withRenderingMode(.alwaysOriginal)
                self.tabBar.items?[i].image = UIImage(named: imageNameForUnselectedState)?.withRenderingMode(.alwaysOriginal)
            }
        }
        
        //UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        
    }
}
