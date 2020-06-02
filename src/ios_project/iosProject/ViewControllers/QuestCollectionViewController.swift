//
//  QuestCollectionViewControllerController.swift
//  iosProject
//
//  Created by Patunique on 25.01.2020.
//  Copyright © 2020 Patunique. All rights reserved.
//

import UIKit
import Parse

class QuestCollectionViewController: UICollectionViewController {
    
    
    static var data : Array<QuestData> = []
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionHeader) {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "QuestHeaderCollectionReusableView", for: indexPath)
            
            return headerView
        }
        fatalError()
    }
    
    override func viewDidLoad() {
        questCollectionView = self.collectionView
        
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.foregroundColor: UIColor.white,
         NSAttributedString.Key.font: UIFont(name: "FuturaPT-Medium", size: 18 )!]
        self.navigationController?.popToRootViewController(animated: true)
        
        questLogic.initList()
        
        QuestCollectionViewController.data = []
        for quest in questList {
            QuestCollectionViewController.data.append(quest)
        }
    }
    
}

extension QuestCollectionViewController: UICollectionViewDelegateFlowLayout {
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //        return CGSize(width: collectionView.frame.width - 50, height: 200)
    //    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return QuestCollectionViewController.data.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestCell", for: indexPath) as! QuestCell
        cell.viewController = self
        cell.data = QuestCollectionViewController.data[indexPath.item]
        return cell
    }
}

class QuestCell: UICollectionViewCell {
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var ratingImage: UIImageView!
    
    var viewController: UIViewController!
    var quest: QuestData?
    
    @IBAction func viewQuest(_ sender: Any) {
        let vc: InfoTableViewController = viewController.storyboard!.instantiateViewController(withIdentifier: "InfoTable") as! InfoTableViewController
        
        vc.quest = self.quest
        
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    var data: QuestData? {
        
        
        didSet {
            guard let data = data else { return }
            
            self.layer.cornerRadius = 20
            mainImageView.layer.cornerRadius = 20
            mainImageView.clipsToBounds = true
            
            self.mainImageView.image = UIImage()
            if let featuredImage = data.image {
                featuredImage.getDataInBackground(block: { (imageData, error) in
                    if let questImageData = imageData {
                        self.mainImageView.image = UIImage(data: questImageData)
                    }
                })
            }
            
            titleLabel.text = data.title
            priceLabel.text = String(data.price) + " баллов"
            scoreLabel.text = data.score
            //distanceLabel.text = data.distance
            quest = data
            
            let rating = data.score ?? "10"
            
            if rating == "10" || rating.first == "9" || rating.first == "8" {
                ratingImage.image = UIImage(named: "5 stars")
            } else if rating.first == "7" || rating.first == "6" {
                ratingImage.image = UIImage(named: "4 stars")
            } else if rating.first == "5" || rating.first == "4" {
                ratingImage.image = UIImage(named: "3 stars")
            } else if rating.first == "4" || rating.first == "3" {
                ratingImage.image = UIImage(named: "2 stars")
            } else {
                ratingImage.image = UIImage(named: "1 star")
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
