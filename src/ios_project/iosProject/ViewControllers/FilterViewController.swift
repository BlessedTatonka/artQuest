//
//  FilterViewController.swift
//  iosProject
//
//  Created by Patunique on 26.02.2020.
//  Copyright © 2020 Patunique. All rights reserved.
//

import UIKit
import Parse


var sortingButtonGroup = [FancyButton]()
var sortingButtonGroupActive = [FancyButton]()
var difficultyButtonGroup = [FancyButton]()
var difficultyButtonGroupActive = [FancyButton]()
var themeGroup = [String]()
var themeGroupActive = [String]()



class FilterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var distanceSlider: UISlider!
    @IBAction func distanceChanged(_ sender: Any) {
    }
    
    @IBOutlet weak var timeSlider: UISlider!
    @IBAction func timeChanged(_ sender: Any) {
    }
    
    @IBAction func leave(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBOutlet var collectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return themeButtonGroup.count
        return themeGroup.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonCell", for: indexPath) as! ButtonCell
        
        cell.data = themeGroup[indexPath.item]
        
        return cell
    }
    
    @IBOutlet weak var fileterNavigationItem: UINavigationItem!
    
    @IBAction func saveAction(_ sender: Any) {
        
        var difficultyArray: [String] = []
        difficultyButtonGroupActive = []
        
        for difficulty in difficultyButtonGroup {
            if (difficulty.selection) {
                difficultyArray.append(difficulty.accessibilityIdentifier ?? "")
                difficultyButtonGroupActive.append(difficulty)
            }
        }
        
        questLogic.initListWithFilters(sortOrder: "1", difficulty: difficultyArray, themes: themeGroupActive)
        
        questCollectionView.reloadData()
        
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        themeGroup = []
        let query = PFQuery(className: "Quest")
        
        do {
            let quests = try query.findObjects()
            for quest in quests {
                let theme = quest["theme"] as! String
                if !themeGroup.contains(theme) {
                    themeGroup.append(theme)
                }
            }
        } catch {
            
        }
        
        if themeGroupActive.isEmpty {
            themeGroupActive = themeGroup
        }
        
        
        sortingButtonGroup = [popularButton, recentButton]
        difficultyButtonGroup =  [easyButton, mediumButton, hardButton]
        
        if (difficultyButtonGroupActive.isEmpty) {
            difficultyButtonGroupActive = difficultyButtonGroup
        }
        
        for button in difficultyButtonGroup {
            button.selection = false
        }
        
        for i in (0...difficultyButtonGroupActive.count - 1) {
            for j in (i...difficultyButtonGroup.count - 1) {
                if (difficultyButtonGroupActive[i].accessibilityIdentifier == difficultyButtonGroup[j].accessibilityIdentifier) {
                    difficultyButtonGroup[j].selection = true
                    break
                }
            }
        }
        
        
        let image: UIImage? = UIImage(named: "EmptyStar")
        distanceSlider.setThumbImage(image, for: .normal)
        distanceSlider.setThumbImage(image, for: .highlighted)
    }
    
    
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    
    
    @IBOutlet weak var lowerTimeLabel: UILabel!
    @IBOutlet weak var upperTimeLabel: UILabel!
    @IBOutlet weak var chosenTimeLabel: UILabel!
    
    
    @IBOutlet weak var popularButton: FancyButton!
    @IBOutlet weak var recentButton: FancyButton!
    
    @IBAction func popularButtonSelectionAction(_ sender: Any) {
        popularButton.toggleGroup(group: sortingButtonGroup)
    }
    
    @IBAction func recentButtonSelectionAction(_ sender: Any) {
        recentButton.toggleGroup(group: sortingButtonGroup)
    }
    
    @IBOutlet weak var easyButton: FancyButton!
    @IBOutlet weak var mediumButton: FancyButton!
    @IBOutlet weak var hardButton: FancyButton!
    
    @IBAction func easyButtonSelectonAction(_ sender: Any) {
        easyButton.toggle()
    }
    
    @IBAction func mediumButtonSelectionAction(_ sender: Any) {
        mediumButton.toggle()
    }
    
    @IBAction func hardButtonSelectionAction(_ sender: Any) {
        hardButton.toggle()
    }
}

class ButtonCell: UICollectionViewCell {
    @IBOutlet weak var button: FancyButton!
    
    @IBAction func buttonSelectionAction(_ sender: Any) {
        button.toggle()
        if button.selection && !themeGroupActive.contains(button.theme) {
            themeGroupActive.append(button.theme)
        } else if !button.selection && themeGroupActive.contains(button.theme) {
            themeGroupActive.remove(at: themeGroupActive.firstIndex(of: button.theme) ?? 0)
        }
    }
    
    var data: String? {
        didSet {
            guard let data = data else { return }
            button.theme = data
            button.setTitle(data, for: .normal)
            if !themeGroupActive.contains(data) {
                button.selection = false
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
