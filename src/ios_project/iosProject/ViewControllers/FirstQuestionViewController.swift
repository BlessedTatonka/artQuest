//
//  FirstQuestionViewController.swift
//  iosProject
//
//  Created by Patunique on 03.03.2020.
//  Copyright © 2020 Patunique. All rights reserved.
//

import UIKit

protocol QuestionProtocol {
    func help()
}

class FirstQuestionViewController: UIViewController, QuestionProtocol {

    //var quest: QuestData!
    
    let question = questionLogic.questionList[questionLogic.index]
    var answerGroup: [FancyButton] = []
    var checked = false
    
    @IBOutlet weak var checkButton: FancyButton!
    @IBAction func checkAndChangeAction(_ sender: Any) {
        
        if chosenLabel == nil {
            return
        }
        
        if !checked {
            checkButton.setTitle("ДАЛЕЕ", for: .normal)
            checked = true
            
            if chosenLabel?.text == question.correctAnswer {
                chosenLabel?.textColor = .white
                chosenButton?.backgroundColor = checkButton.backgroundColor
            } else {
                chosenLabel?.textColor = .white
                chosenButton?.backgroundColor = .gray
                
                if firstAnswerLabel.text == question.correctAnswer {
                    chosenLabel = firstAnswerLabel
                    chosenButton = firstAnswerButton
                } else if secondAnswerLabel.text == question.correctAnswer {
                    chosenLabel = secondAnswerLabel
                    chosenButton = secondAnswerButton
                } else if thirdAnswerLabel.text == question.correctAnswer {
                    chosenLabel = thirdAnswerLabel
                    chosenButton = thirdAnswerButton
                } else if fourthAnswerLabel.text == question.correctAnswer {
                    chosenLabel = fourthAnswerLabel
                    chosenButton = fourthAnswerButton
                }
                
                chosenLabel?.textColor = .white
                chosenButton?.backgroundColor = checkButton.backgroundColor
                
            }
            
            firstAnswerButton.isUserInteractionEnabled = false
            secondAnswerButton.isUserInteractionEnabled = false
            thirdAnswerButton.isUserInteractionEnabled = false
            fourthAnswerButton.isUserInteractionEnabled = false
            
            return
        }
        
        
        let vc = questionLogic.checkAndChange(storyboard: self.storyboard!)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var firstAnswerButton: FancyButton!
    @IBOutlet weak var firstAnswerLabel: UILabel!
    @IBOutlet weak var secondAnswerButton: FancyButton!
    @IBOutlet weak var secondAnswerLabel: UILabel!
    @IBOutlet weak var thirdAnswerButton: FancyButton!
    @IBOutlet weak var thirdAnswerLabel: UILabel!
    @IBOutlet weak var fourthAnswerButton: FancyButton!
    @IBOutlet weak var fourthAnswerLabel: UILabel!
    
    var chosenLabel: UILabel? = nil
    var chosenButton: UIButton? = nil
    
    @IBAction func firstAnswerClicked(_ sender: Any) {
        firstAnswerButton.toggleGroup(group: answerGroup)
        changeLabelsColor(label: firstAnswerLabel, button: firstAnswerButton)
    }
    
    @IBAction func secondAnswerClicked(_ sender: Any) {
        secondAnswerButton.toggleGroup(group: answerGroup)
        changeLabelsColor(label: secondAnswerLabel, button: secondAnswerButton)
    }
    
    @IBAction func thirdAnswerClicked(_ sender: Any) {
        thirdAnswerButton.toggleGroup(group: answerGroup)
        changeLabelsColor(label: thirdAnswerLabel, button: thirdAnswerButton)
    }
    
    @IBAction func fourthAnswerClicked(_ sender: Any) {
        fourthAnswerButton.toggleGroup(group: answerGroup)
        changeLabelsColor(label: fourthAnswerLabel, button: fourthAnswerButton)
    }
    
    func changeLabelsColor(label: UILabel, button: UIButton) {
        firstAnswerLabel.textColor = firstAnswerButton.selectionOffTextColor
        secondAnswerLabel.textColor = secondAnswerButton.selectionOffTextColor
        thirdAnswerLabel.textColor = thirdAnswerButton.selectionOffTextColor
        fourthAnswerLabel.textColor = fourthAnswerButton.selectionOffTextColor
        
        chosenLabel = label
        chosenButton = button
        label.textColor = firstAnswerButton.selectionOnTextColor
    }
    
    
    func fillAnswers() {
        firstAnswerLabel.text = question.answerList[0]
        secondAnswerLabel.text = question.answerList[1]
        thirdAnswerLabel.text = question.answerList[2]
        fourthAnswerLabel.text = question.answerList[3]

        answerGroup = [firstAnswerButton, secondAnswerButton, thirdAnswerButton, fourthAnswerButton]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillAnswers()

        titleLabel.text = question.title
        questionLogic.index += 1
        
        self.navigationItem.title =  "\(questionLogic.index)/\(questionLogic.questionList.count)"
    }
    

    
    @IBAction func QuitAction(_ sender: Any) {
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to quit? All data will be lost.", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Quit", style: .default, handler: { (action) -> Void in
            let array = self.navigationController?.viewControllers
            
            self.navigationController?.popToViewController(array![1], animated: true)
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            return
        }
        
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    @IBOutlet weak var helpButton: UIBarButtonItem!
    @IBAction func getHelp(_ sender: Any) {
        if (!checked) {
            FancyAlertView.instance.showAlert(question: self)
        }
    }
    
    func help() {
        helpButton.isEnabled = false
        var sum = 0
        if (firstAnswerLabel.text != question.correctAnswer && sum < 2) {
            firstAnswerButton.isEnabled = false
            firstAnswerLabel.text = ""
            sum += 1
        }
        if (secondAnswerLabel.text != question.correctAnswer && sum < 2) {
            secondAnswerButton.isEnabled = false
            secondAnswerLabel.text = ""
            sum += 1
        }
        if (thirdAnswerLabel.text != question.correctAnswer && sum < 2) {
            thirdAnswerButton.isEnabled = false
            thirdAnswerLabel.text = ""
            sum += 1
        }
    }
    
}
