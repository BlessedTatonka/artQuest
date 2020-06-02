//
//  FinalViewController.swift
//  iosProject
//
//  Created by Patunique on 18.03.2020.
//  Copyright © 2020 Patunique. All rights reserved.
//

import UIKit
import Parse

class FinalViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        cell.data = self.data[indexPath.item]
        cell.contentView.layer.cornerRadius = 10
        return cell
    }
    
    
    
    fileprivate var data : Array<ProductData> = []
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FinalHeader", for: indexPath) as! FinalHeaderCollectionReusableView
                        
            headerView.initData()
            
            return headerView
//        } else if kind == UICollectionView.elementKindSectionFooter {
//            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FinalFooter", for: indexPath) as! CongratsFooterCollectionReusableView
//
//            footerView.collectionView = self
//
//            return footerView
        } else {
            fatalError()
        }
    }
    
    
    
    func initData() {
        
        let query = PFQuery(className: "Product")
        
        do {
            let products = try query.findObjects()
            for product in products {
                if !((product["price"] as! Int) > (currentUser.money! + currentQuest.price)) {
                    self.data.append(ProductData(title: product["title"] as! String, imageURL: product["imageURL"] as! String, price: product["price"] as! Int))
                    print("qweqweqweqw")
                }
            }
        } catch {
            
        }
    }
    
    @IBAction func QuitAction(_ sender: Any) {
        let array = self.navigationController!.viewControllers
        self.navigationController?.popToViewController(array[1], animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    // Hide the Navigation Bar
//            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    // Show the Navigation Bar
//            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
    
}

class FinalHeaderCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var rewardLabel: UILabel!
    
    @IBOutlet weak var overallMoneyLabel: UILabel!
        
    func initData() {
        rewardLabel.text = String(currentQuest.price) + " баллов"
        
        currentUser.money! += currentQuest.price
        currentUser.score! += currentQuest.price
        overallMoneyLabel.text = "Всего у вас в сумме " + String(currentUser.money!) + " баллов"
        
        currentUser.quests?.append("\(currentQuest.questId as! String);\(Int(Date.timeIntervalSinceReferenceDate))")
        print(currentUser.quests!)
        userLogic.saveCurrentUser()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class FinalFooterCollectionReusableView: UICollectionReusableView {
    
    var collectionView = UIViewController()
    
    func initData() {
       
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

