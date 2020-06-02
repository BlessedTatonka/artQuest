//
//  TableViewController.swift
//  iosProject
//
//  Created by Patunique on 22.01.2020.
//  Copyright © 2020 Patunique. All rights reserved.
//

import UIKit
import Parse

struct TableData {
    var objectId: String!
    var username: String!
    var image: PFFileObject?
    var score: Int!
    var monthScore: Int!  //############## CHANGE
    var weekScore: Int!   //############## CHANGE
}

var tableViewController = UIViewController()

class TableViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var data: [TableData] = []
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var currentUserCounterLabel: UILabel!
    @IBOutlet weak var currentUserImageView: UIImageView!
    @IBOutlet weak var currentUserNameLabel: UILabel!
    @IBOutlet weak var currentUserScoreLabel: UILabel!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RatingCell", for: indexPath) as! RatingCell
        
        cell.objectId = data[indexPath.item].objectId
        
        cell.counterLabel.text = String(indexPath.item + 1)
        cell.nameLabel.text = data[indexPath.item].username
        
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            cell.userPoints.text = String(data[indexPath.item].score)
        case 1:
            cell.userPoints.text = String(data[indexPath.item].monthScore)
        case 2:
            cell.userPoints.text = String(data[indexPath.item].weekScore)
        default:
            break
        }
        
        cell.userImage.layer.cornerRadius = cell.userImage.bounds.width / 2
        if let featuredImage = data[indexPath.item].image {
            featuredImage.getDataInBackground(block: { (imageData, error) in
                if let questImageData = imageData {
                    cell.userImage.image = UIImage(data: questImageData)
                }
            })
        }
        
        return cell
    }
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    func initList() {
        data = []
        
        let query = PFUser.query()
        
        do {
            let users = try query!.findObjects()
            let questQuery = PFQuery.init(className: "Quest")
            for user in users {
                
                var overallScore = 0
                var monthScore = 0
                var weekScore = 0
                
                for userQuest in (user["quests"] as! Array<String>) {
                    let time = Int(userQuest.split(separator: ";")[1])
                    let quest = try questQuery.getObjectWithId(String(userQuest.split(separator: ";")[0]))
                    
                    overallScore += quest["price"] as! Int
                    
                    if time! < 2629746 {
                        monthScore += quest["price"] as! Int
                    }
                    
                    if time! < 604800 {
                        weekScore += quest["price"] as! Int
                    }
                }
                
                
                
                data.append(TableData(
                    objectId: user.objectId,
                    username: user["username"] as? String,
                    image: user["image50x50"] as? PFFileObject,
                    score: overallScore,
                    monthScore: monthScore,
                    weekScore: weekScore))
                
                if user.objectId == currentUser.objectId {
                    switch self.segmentedControl.selectedSegmentIndex {
                    case 0:
                        currentUserScoreLabel.text = String(overallScore)
                    case 1:
                        currentUserScoreLabel.text = String(monthScore)
                    case 2:
                        currentUserScoreLabel.text = String(weekScore)
                    default:
                        break
                    }
                }
            }
        } catch {
            
        }
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            data = data.sorted(by: {$0.score > $1.score})
        case 1:
            data = data.sorted(by: {$0.monthScore > $1.monthScore})
        case 2:
            data = data.sorted(by: {$0.weekScore > $1.weekScore})
        default:
            break
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white,
             NSAttributedString.Key.font: UIFont(name: "FuturaPT-Medium", size: 18 )!]
        self.navigationController?.popToRootViewController(animated: true)
        
        tableViewController = self
        segmentedControl.selectedSegmentIndex = 0
        initList()
        
        bottomView.layer.cornerRadius = 10
        //currentUserCounterLabel.text = String(data.firstIndex(where: {$0.objectId == currentUser.objectId})! + 1)
        currentUserNameLabel.text = currentUser.username
        currentUserScoreLabel.text = String(currentUser.score!)
        currentUserImageView.layer.cornerRadius = currentUserImageView.bounds.width / 2
        if let featuredImage = currentUser.image {
            featuredImage.getDataInBackground(block: { (imageData, error) in
                if let profileImageData = imageData {
                    self.currentUserImageView.image = UIImage(data: profileImageData)
                }
            })
        }
        
        
        initSegmentedControl()
        
        view.addSubview(segmentedControlContainerView)
        segmentedControlContainerView.addSubview(segmentedControl)
        segmentedControlContainerView.addSubview(bottomUnderlineView)
        
        // Constrain the container view to the view controller
        let safeLayoutGuide = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            segmentedControlContainerView.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor),
            //segmentedControlContainerView.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor, constant: 20),
            segmentedControlContainerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            segmentedControlContainerView.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor),
            segmentedControlContainerView.heightAnchor.constraint(equalToConstant: Constants.segmentedControlHeight)
        ])
        
        // Constrain the segmented control to the container view
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: segmentedControlContainerView.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: segmentedControlContainerView.leadingAnchor),
            segmentedControl.centerXAnchor.constraint(equalTo: segmentedControlContainerView.centerXAnchor),
            segmentedControl.centerYAnchor.constraint(equalTo: segmentedControlContainerView.centerYAnchor)
        ])
        
        // Constrain the underline view relative to the segmented control
        NSLayoutConstraint.activate([
            bottomUnderlineView.bottomAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            bottomUnderlineView.heightAnchor.constraint(equalToConstant: Constants.underlineViewHeight),
            leadingDistanceConstraint,
            bottomUnderlineView.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1 / CGFloat(segmentedControl.numberOfSegments))
        ])
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    private enum Constants {
        static let segmentedControlHeight: CGFloat = 50
        static let underlineViewColor: UIColor = UIColor(displayP3Red: 246 / 255, green: 1 / 255, blue: 118 / 255, alpha: 1)
        static let underlineViewHeight: CGFloat = 3
    }
    
    // Container view of the segmented control
    private lazy var segmentedControlContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    func initSegmentedControl() {
        // Remove background and divider colors
        //segmentedControl.backgroundColor = self.view.backgroundColor
        segmentedControl.tintColor = .clear
        // Select first segment by default
        segmentedControl.selectedSegmentIndex = 0
        
        // Change text color and the font of the NOT selected (normal) segment
        
        // Set up event handler to get notified when the selected segment changes
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        
        // Return false because we will set the constraints with Auto Layout
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                   NSAttributedString.Key.font: UIFont(name: "futurabookc", size: 16.0)!]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
    }
    
    // The underline view below the segmented control
    private lazy var bottomUnderlineView: UIView = {
        let underlineView = UIView()
        underlineView.backgroundColor = Constants.underlineViewColor
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        return underlineView
    }()
    
    private lazy var leadingDistanceConstraint: NSLayoutConstraint = {
        return bottomUnderlineView.leftAnchor.constraint(equalTo: segmentedControl.leftAnchor)
    }()
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        changeSegmentedControlLinePosition()
        
        initList()
        tableView.reloadData()
        
    }
    
    // Change position of the underline
    private func changeSegmentedControlLinePosition() {
        let segmentIndex = CGFloat(segmentedControl.selectedSegmentIndex)
        let segmentWidth = segmentedControl.frame.width / CGFloat(segmentedControl.numberOfSegments)
        let leadingDistance = segmentWidth * segmentIndex
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.leadingDistanceConstraint.constant = leadingDistance
            //self?.layoutIfNeeded()
        })
    }
    
}

class RatingCell: UITableViewCell {
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userPoints: UILabel!
    
    var objectId: String?
    
    @IBAction func openUserProfile(_ sender: Any) {
        let vc: ProfileCollectionViewController = tableViewController.storyboard!.instantiateViewController(withIdentifier: "ProfileCollection") as! ProfileCollectionViewController
        do {
            vc.user = try userLogic.initializeUser(PFUser.query()?.getObjectWithId(objectId!) as! PFUser)
        } catch {
            print(error)
        }
        
        tableViewController.navigationController?.pushViewController(vc, animated: true)
    }
    
}
