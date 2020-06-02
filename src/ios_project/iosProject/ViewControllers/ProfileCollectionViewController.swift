//
//  ProfileCollectionViewControllerController.swift
//  iosProject
//
//  Created by Patunique on 22.01.2020.
//  Copyright © 2020 Patunique. All rights reserved.
//

import UIKit
import Parse

class ProfileCollectionViewController: UICollectionViewController {
    @IBOutlet var collection: UICollectionView!
    var headerView = ProfileHeaderCollectionReusableView()
    var user : User? = currentUser
    //var header = ProfileHeaderCollectionReusableView()
    fileprivate var data : Array<QuestData> = []
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionHeader) {
            headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ProfileHeaderCollectionReusableView", for: indexPath) as! ProfileHeaderCollectionReusableView
            headerView.user = self.user
            headerView.initData()
            return headerView
        }
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //initData()
        if (user == nil) {
            user = currentUser
        }
        
        questLogic.initListForUser(user: user!)
        data = []
        for quest in profileList {
            data.append(quest)
        }
        headerView.initData()
        
        self.collection.reloadData()
        self.reloadInputViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        user = nil
    }
    
}

extension ProfileCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 50, height: 200)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestCell", for: indexPath) as! QuestCell
        cell.data = self.data[indexPath.item]
        cell.viewController = self
        return cell
    }
}

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    
    @IBOutlet weak var quests: UILabel!
    @IBOutlet weak var subscribers: UILabel!
    @IBOutlet weak var subscriptions: UILabel!
    @IBOutlet weak var subscribeButton: FancyButton!
    
    var user: User!
    
    @IBAction func subscribe(_ sender: Any) {
        subscribeButton.toggle()
        currentUser.subscriprions?.append(user.objectId)
        //user.subscribers?.append(currentUser.objectId)
        
        
        
        var query = PFUser.query()
        query?.getObjectInBackground(withId: user.objectId) {
            (user: PFObject?, error: Error?) -> Void in
            if error != nil {
                print(error)
            } else {
                user?.saveInBackground()
            }
            
        }
        userLogic.saveCurrentUser()
    }
    
    func initData() {
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        
        if let featuredImage = user.image {
            featuredImage.getDataInBackground(block: { (imageData, error) in
                if let profileImageData = imageData {
                    self.profileImageView.image = UIImage(data: profileImageData)
                }
            })
        }
        
        nameLabel.text = user.username
        moneyLabel.text = String(user.money!) + " баллов"
        quests.text = String((user.quests ?? []).count)
        //subscribers.text = String(user.subscribers.count)
        subscriptions.text = String(user.subscriprions.count)
        
        subscribeButton.isHidden = (user.objectId == currentUser.objectId)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

