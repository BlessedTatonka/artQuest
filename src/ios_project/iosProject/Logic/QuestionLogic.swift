//
//  QuestionLogic.swift
//  iosProject
//
//  Created by Patunique on 05.03.2020.
//  Copyright © 2020 Patunique. All rights reserved.
//

import Foundation
import Parse

struct QuestionData {
    var type: Int
    var title: String
    var answerList: [String]
    var correctAnswer: String
    var hint: String
    var image: PFFileObject?
    var score: Int
    var explanation: String
}

class QuestionLogic {
    var questionList: [QuestionData] = []
    var index: Int = 0
    
    func fillQuestionList(questId: String) {
        questionList.removeAll()
        index = 0
        
        do {
            let query = PFQuery(className: "Quest")
            let questionsIds = try query.getObjectWithId(questId)["questionsId"] as! [String]
            
            for questionId in questionsIds {
                readQuestion(questionId: questionId)
            }
        } catch {

        }
    }
    
    var img = UIImage.init()
    
    func readQuestion(questionId: String) {
        
        do {
            let query = PFQuery(className: "Questions")

            let question = try query.getObjectWithId(questionId)
            
            var qd = QuestionData(
                type: question["type"] as! Int,
                title: question["title"] as! String,
                answerList: question["answerList"] as! [String],
                correctAnswer: question["correctAnswer"] as! String,
                hint: question["hint"] as! String,
                score: question["score"] as! Int,
                explanation: question["explanation"] as! String)
            
            if question["image"] as? PFFileObject != nil {
                qd.image = (question["image"] as! PFFileObject)
            }
            
            questionList.append(qd)

        } catch {

        }
    }
    
    
    func checkAndChange(storyboard: UIStoryboard) -> UIViewController {
        var vc: UIViewController
        
        if questionList.count <= index {
            vc = storyboard.instantiateViewController(withIdentifier: "QuestResult") as! ResultQuestCollectionViewlController
        } else {
            switch questionList[index].type {
            case 1:
                vc = storyboard.instantiateViewController(withIdentifier: "FirstQuestion") as! FirstQuestionViewController
                break
            case 2:
                vc = storyboard.instantiateViewController(withIdentifier: "SecondQuestion") as! SecondQuestionViewController
                break
            case 3:
                vc = storyboard.instantiateViewController(withIdentifier: "ThirdQuestion") as! ThirdQuestionViewController
                break
            default:
                return UIViewController()
            }
        }
        
        return vc
    }
}
