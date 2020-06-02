//
//  UserLogic.swift
//  iosProject
//
//  Created by Patunique on 13.02.2020.
//  Copyright © 2020 Patunique. All rights reserved.
//

import Foundation
import Parse
    
struct User {
    var objectId: String!
    var username: String!
    var email: String!
    var money: Int?
    var score: Int?
    var quests: Array<String>?
    var image50x50: PFFileObject?
    var image: PFFileObject?
    //var password: String!
    var phoneNumber: String?
    var notifications: Bool?
    var soundEffects: Bool?
    var subscriprions: Array<String>!
    var subscribersId: String!
}

var currentUser = User()

class UserLogic {
    
    func initializeUser(_ pfuser: PFUser) -> User {
  
        var user = User()
        
        user.objectId = pfuser.objectId
        user.username = pfuser["username"] as? String
        user.email = pfuser["email"] as? String
        user.image50x50 = pfuser["image50x50"] as? PFFileObject
        user.image = pfuser["image"] as? PFFileObject
        user.money = pfuser["money"] as? Int
        user.score = pfuser["score"] as? Int
        user.notifications = pfuser["notifications"] as? Bool
        user.soundEffects = pfuser["soundEffects"] as? Bool
        user.quests = pfuser["quests"] as? Array<String>
        questLogic.initListForUser(user: user)
        //print("AAAA\((pfuser["quests"] as? Array<String>)?.first)")
        user.phoneNumber = pfuser["phoneNumber"] as? String
        
        user.subscribersId = pfuser["subscribersId"] as? String
        user.subscriprions = pfuser["subscriptions"] as? Array<String> ?? []
                
        return user
    }
    
    func saveCurrentUser() {
        let pfuser = PFUser.current()!
        let user = currentUser
        
        pfuser["username"] = user.username
        pfuser["email"] = user.email
        //user["password"] = password
        pfuser["phoneNumber"] = user.phoneNumber ?? "-"
        pfuser["money"] = user.money ?? 0
        pfuser["score"] = user.score ?? 0
        pfuser["quests"] = user.quests ?? []
        //pfuser["image50x50"] = user.image50x50
        pfuser["image"] = user.image
        pfuser["notifications"] = user.notifications ?? true
        pfuser["soundEffects"] = user.soundEffects ?? true
        pfuser["subscriptions"] = user.subscriprions ?? []
        pfuser["subscribersId"] = user.subscribersId
        pfuser.saveInBackground() {
            (success: Bool, error: Error?) in
            if (success) {
              // The object has been saved.
            } else {
                print(error)
            }
        }
    }
    
}
