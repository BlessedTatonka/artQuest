//
//  InfoQuestViewController.swift
//  iosProject
//
//  Created by Patunique on 26.02.2020.
//  Copyright © 2020 Patunique. All rights reserved.
//

import UIKit
import MapKit

class InfoQuestViewController: UIViewController, MKMapViewDelegate {
    
    var quest: QuestData!
    
    @IBOutlet weak var topUmageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBAction func startNewQuestionsSession(_ sender: Any) {
        
        let delay = 1 // seconds
        spinner.isHidden = false
        spinner.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
            
            questionLogic.fillQuestionList(questId: self.quest.questId)
            
            if questionLogic.questionList.count < 1 {
                return
            }
            
            let vc = questionLogic.checkAndChange(storyboard: self.storyboard!)
            
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    func initView() {
        titleLabel.text = quest?.title
        themeLabel.text = quest?.theme
        descriptionTextView.text = quest?.description
        //topUmageView.image
        priceLabel.text = String(quest!.price) + " рублей"
        ageLabel.text = quest?.age
        timeLabel.text = String(quest!.time) + " минут"
        difficultyLabel.text = quest?.difficulty
    }
    
    func initNavigationController() {
        
        //self.navigationController?.navigationBar.isTranslucent = flag
        //self.navigationController?.view.backgroundColor = flag ? .clear : .black
         
    }
    
    override func viewDidLoad() {
        spinner.isHidden = true
        super.viewDidLoad()
       
        initView()
        
        initNavigationController()
        
        
   }
}

