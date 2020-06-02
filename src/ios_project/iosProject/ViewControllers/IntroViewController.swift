//
//  IntroViewController.swift
//  iosProject
//
//  Created by Patunique on 15.01.2020.
//  Copyright © 2020 Patunique. All rights reserved.
//

import UIKit
import Parse

var preferences = [FancyButton]()

class IntroViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IntroCell", for: indexPath) as! IntroCell
        
        if indexPath.item == 0 {
            cell.firstButton.setTitle("Живопись", for: .normal)
            cell.secondButton.setTitle("Фотография", for: .normal)
            cell.thirdButton.setTitle("Архитектура", for: .normal)
            cell.forthButton.setTitle("Перфомансы", for: .normal)
            cell.fifthButton.setTitle("Инсталляции", for: .normal)
            cell.sixthButton.setTitle("Дизайн", for: .normal)
            cell.seventhButton.setTitle("Видео", for: .normal)
        } else if indexPath.item == 1 {
            cell.firstButton.setTitle("other", for: .normal)
            cell.secondButton.setTitle("other", for: .normal)
            cell.thirdButton.setTitle("other", for: .normal)
            cell.forthButton.setTitle("other", for: .normal)
            cell.fifthButton.setTitle("other", for: .normal)
            cell.sixthButton.setTitle("other", for: .normal)
            cell.seventhButton.setTitle("other", for: .normal)
        }
        
        
        preferences.append(cell.firstButton)
        preferences.append(cell.secondButton)
        preferences.append(cell.thirdButton)
        preferences.append(cell.forthButton)
        preferences.append(cell.fifthButton)
        preferences.append(cell.sixthButton)
        preferences.append(cell.seventhButton)
        return cell
    }
    
 
    override func viewDidLoad() {
       super.viewDidLoad()
       
    }
    
    
    @IBAction func popView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

class IntroCell: UICollectionViewCell {
    @IBOutlet weak var firstButton: FancyButton!
    @IBOutlet weak var secondButton: FancyButton!
    @IBOutlet weak var thirdButton: FancyButton!
    @IBOutlet weak var forthButton: FancyButton!
    @IBOutlet weak var fifthButton: FancyButton!
    @IBOutlet weak var sixthButton: FancyButton!
    @IBOutlet weak var seventhButton: FancyButton!
    
    
    @IBAction func firstButtonClicked(_ sender: Any) {
        firstButton.toggle()
    }
    
    @IBAction func secondButtonClicked(_ sender: Any) {
        secondButton.toggle()
    }
    
    @IBAction func thirdButtonClicked(_ sender: Any) {
        thirdButton.toggle()
    }
    
    @IBAction func fourthButtonClicked(_ sender: Any) {
        forthButton.toggle()
    }
    
    @IBAction func fifthButtonClicked(_ sender: Any) {
        fifthButton.toggle()
    }
    
    @IBAction func sixthButtonClicked(_ sender: Any) {
        sixthButton.toggle()
    }
    
    @IBAction func seventhButtonClicked(_ sender: Any) {
        seventhButton.toggle()
    }
    
}
