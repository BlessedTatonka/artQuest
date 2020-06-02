//
//  ResultQuestCollectionViewlController.swift
//  iosProject
//
//  Created by Patunique on 07.03.2020.
//  Copyright © 2020 Patunique. All rights reserved.
//

import UIKit

class ResultQuestCollectionViewlController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var firstStar: UIButton!
    @IBOutlet weak var secondStar: UIButton!
    @IBOutlet weak var thirdStar: UIButton!
    @IBOutlet weak var fourthStar: UIButton!
    @IBOutlet weak var fifthStar: UIButton!
    
    @IBAction func oneStarRate(_ sender: Any) {
    }
    
    @IBAction func tick(sender: UIButton) {
        clearStars()
        sender.setImage(UIImage(named:"FilledStar"), for: .normal)
        
        sender.isUserInteractionEnabled = false
    }
    
    @IBAction func tick2(sender: UIButton) {
        tick(sender: firstStar)
        sender.setImage(UIImage(named:"FilledStar"), for: .normal)
        
        sender.isUserInteractionEnabled = false
    }
    
    @IBAction func tick3(sender: UIButton) {
        tick2(sender: secondStar)
        sender.setImage(UIImage(named:"FilledStar"), for: .normal)
        
        sender.isUserInteractionEnabled = false
    }
    
    @IBAction func tick4(sender: UIButton) {
        tick3(sender: thirdStar)
        sender.setImage(UIImage(named:"FilledStar"), for: .normal)
        sender.isUserInteractionEnabled = false
    }
    
    @IBAction func tick5(sender: UIButton) {
        tick4(sender: fourthStar)
        sender.setImage(UIImage(named:"FilledStar"), for: .normal)
        sender.isUserInteractionEnabled = false
    }
    
    
    
    
    func clearStars() {
        firstStar.imageView?.image = UIImage(named: "EmptyStar")
        secondStar.imageView?.image = UIImage(named: "EmptyStar")
        thirdStar.imageView?.image = UIImage(named: "EmptyStar")
        fourthStar.imageView?.image = UIImage(named: "EmptyStar")
        fifthStar.imageView?.image = UIImage(named: "EmptyStar")
    }
    
    @IBAction func QuitAction(_ sender: Any) {
        let array = self.navigationController?.viewControllers
        
        self.navigationController?.popToViewController(array![1], animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = currentQuest.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Hide the Navigation Bar
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
