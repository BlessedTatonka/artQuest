//
//  SecondQuestionViewController.swift
//  iosProject
//
//  Created by Patunique on 07.03.2020.
//  Copyright © 2020 Patunique. All rights reserved.
//

import UIKit

class SecondQuestionViewController: UIViewController, QuestionProtocol {
    //var quest: QuestData!
    
    let question = questionLogic.questionList[questionLogic.index]
    var checked = false
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var answerTextField: UITextField!
    
    @IBOutlet weak var correctLabel: UILabel!
    @IBOutlet weak var rightAnswerLabel: UILabel!
    @IBOutlet weak var explanationTextField: UITextView!
    
    @IBOutlet weak var checkButton: FancyButton!
    @IBAction func checkAndChangeAction(_ sender: Any) {
                
        if answerTextField.text == "" {
            return
        }
        
        if !checked {
            checkButton.setTitle("ДАЛЕЕ", for: .normal)
            checked = true
            
            if answerTextField.text == question.correctAnswer {
                answerTextField.backgroundColor = checkButton.backgroundColor
                
                correctLabel.text = "ВЕРНО"
                
            } else {
                answerTextField.backgroundColor = .gray
                
                correctLabel.text = "НЕВЕРНО"
                rightAnswerLabel.text = "Правильный ответ: " + question.correctAnswer

                rightAnswerLabel.isHidden = false
                explanationTextField.text = question.explanation
                explanationTextField.isHidden = false
                
            }
            
            correctLabel.isHidden = false
            
            
            return
        }
        
        
        correctLabel.isEnabled = true
        explanationTextField.text = question.explanation
        
        let vc = questionLogic.checkAndChange(storyboard: self.storyboard!)
        
        navigationController?.pushViewController(vc, animated: true)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        correctLabel.isHidden = true
        rightAnswerLabel.isHidden = true
        explanationTextField.isHidden = true
        
        titleLabel.text = questionLogic.questionList[questionLogic.index].title
        questionLogic.index += 1
        
//        answerTextField.layer.borderColor = self.presentingViewController?.view.backgroundColor as! CGColor
        answerTextField.layer.cornerRadius = 10
        answerTextField.borderStyle = UITextField.BorderStyle.none

        var myMutableStringTitle = NSMutableAttributedString()
        let Name  = "Введите текст" // PlaceHolderText

        myMutableStringTitle = NSMutableAttributedString(string:Name, attributes: [NSAttributedString.Key.font:UIFont(name: "FuturaBookC", size: 16.0)!]) // Font
        myMutableStringTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(displayP3Red: 111 / 255, green: 115 / 255, blue: 131 / 255, alpha: 1), range:NSRange(location:0,length: Name.count))    // Color
        answerTextField.attributedPlaceholder = myMutableStringTitle

        
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
        rightAnswerLabel.text = "Первая буква: " + question.correctAnswer[0]
        rightAnswerLabel.isHidden = false
    }
}

extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}
