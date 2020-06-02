//
//  QuestLogic.swift
//  iosProject
//
//  Created by Patunique on 26.02.2020.
//  Copyright © 2020 Patunique. All rights reserved.
//

import Foundation
import Parse

struct QuestData {
    var questId: String!
    var title: String!
    var image: PFFileObject?
    var price: Int!
    var score: String!
    var theme: String!
    var difficulty: String!
    var location: String!
    var time: Int!
    var description: String!
    var age: String!
}

var questList = [QuestData]()
var profileList = [QuestData]()

var questCollectionView: UICollectionView!
var profileCollectionView: UICollectionView!

var currentQuest = QuestData()

class QuestLogic: NSObject {
      
    func getQuestData(quest: PFObject) -> QuestData {
        return QuestData(
            questId: quest.objectId!,
            title: quest["title"] as? String,
            image: quest["image"] as? PFFileObject,
            price: quest["price"] as? Int,
            score: quest["score"] as? String,
            theme: quest["theme"] as? String,
            difficulty: quest["difficulty"] as? String,
            location: quest["location"] as? String,
            //location: "ул. Крымский Вал, 9 строение 32, Москва",
            time: quest["time"] as? Int,
            description: quest["description"] as? String,
            age: quest["age"] as? String)
    }
    
    func initList() {
        let query = PFQuery(className: "Quest")

        do {
            let quests = try query.findObjects()
            for quest in quests {
                questList.append(getQuestData(quest: quest))
            }
            
            //questList = questList.sorted(by: { $0.score > $1.score })
        } catch {
            
        }
    }
    
    func initListForUser(user: User) {
        profileList = []
        let quests = user.quests
        print("Quests \(quests)")
        let query = PFQuery(className: "Quest")

        if quests != nil {
            for questId in quests! {
                print("AAAA\(questId.split(separator: ";")[0])")
                do {
                    let quest = try query.getObjectWithId(String(questId.split(separator: ";")[0]))
                    profileList.append(getQuestData(quest: quest))
                } catch {

                }
                
            }
        }
    }
    
    func initListWithFilters(sortOrder: String, difficulty: [String], themes: [String]) {
        let query = PFQuery(className: "Quest")
        
        QuestCollectionViewController.data = []
        questList = [QuestData]()

        print(difficulty)
        
        do {
            let quests = try query.findObjects()
            for quest in quests {

                
                if (difficulty.contains(quest["difficulty"] as! String + "Label") && themes.contains(quest["theme"] as! String)) || difficulty.isEmpty || themes.isEmpty {
                        questList.append(getQuestData(quest: quest))
                }
            }

            if (sortOrder == "popular") {
                //questList = questList.sorted(by: { $0.createdAt > $1.createdAt })
            } else if (sortOrder == "recent") {
                //questList = questList.sorted(by: { $0.score > $1.score })
            }
            
            for quest in questList {
                QuestCollectionViewController.data.append(quest)
            }
            
            questCollectionView.reloadData()
        } catch {

        }
    }
    
}

protocol ObserverProtocol: class
{
    func refreshUI()
}
