//
//  QuestCollectionViewControllerController.swift
//  iosProject
//
//  Created by Patunique on 25.01.2020.
//  Copyright © 2020 Patunique. All rights reserved.
//

import UIKit
import Parse

struct ProductData {
    var title: String
    var imageURL: String
    var price: Int
}


class ShopCollectionViewController: UICollectionViewController {
    fileprivate var data : Array<ProductData> = []
    
    var headerView: ShopHeaderCollectionReusableView!
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionHeader) {
            headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ShopHeaderCollectionReusableView", for: indexPath) as! ShopHeaderCollectionReusableView
            
            headerView.initData()
            
            return headerView
        }
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.foregroundColor: UIColor.white,
         NSAttributedString.Key.font: UIFont(name: "FuturaPT-Medium", size: 18 )!]
        self.navigationController?.popToRootViewController(animated: true)
        
        initData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        headerView!.moneyLabel.text = String(currentUser.money!) + " баллов"
    }
    
    func initData() {
        
        let query = PFQuery(className: "Product")
        
        do {
            let products = try query.findObjects()
            for product in products {
                data.append(ProductData(title: product["title"] as! String, imageURL: product["imageURL"] as! String, price: product["price"] as! Int))
                
            }
        } catch {
            
        }
    }

}

extension ShopCollectionViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.frame.width / 2, height: 200)
//    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        cell.data = self.data[indexPath.item]
        cell.contentView.layer.cornerRadius = 10
        return cell
    }
}

class ShopHeaderCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var moneyLabel: UILabel!
    
    func initData() {
        moneyLabel.text = String(currentUser.money!) + " баллов"
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


class ProductCell: UICollectionViewCell {
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var data: ProductData? {
        didSet {
            guard let data = data else { return }
            
            let url = URL(string: data.imageURL)!
            downloadImage(from: url)

            print(data.title)
            titleLabel.text = data.title
            priceLabel.text = String(data.price) + " баллов"
            //distanceLabel.text = data.distance
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.mainImageView.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
