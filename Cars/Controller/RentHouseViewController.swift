//
//  LoginView.swift
//  Cars
//
//  Created by Zho on 24.04.2018.
//  Copyright © 2018 Zho. All rights reserved.

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

@available(iOS 11.0, *)
class RentHouseViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let authService = AuthenticationService()
    var goods = [Goods]()
    var categoryGoods = [Goods]()
    var category = String()
//Рисую UI
    private lazy var welcomeLabel : UILabel = {
        let label = UILabel()
        label.text = "Возможно,это то что вам нужно"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont(name: "HelveticaNeue", size: 14.0)
        return label
    }()
    
    private lazy var houseLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width-30, height: view.frame.width * 0.77)
        layout.sectionInset.left = 35
        layout.sectionInset.right = 35
        layout.minimumLineSpacing = view.frame.width/20
        layout.sectionInset.bottom = view.frame.width * 0.38
        layout.scrollDirection = .vertical
        return layout
    }()
    
    private lazy var houseCollectionView : UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: houseLayout)
        view.delegate = self
        view.dataSource = self
        view.register(HouseCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.backgroundColor = .white

        return view
    }()
//
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        print(self.view.frame.width, self.view.frame.height)
        print(goods.count)
        navBar()
        setupViews()
        setupFrame()
        if (goods.count != 0) {
            updateCategoryGoods()
        } else {
            self.showMessage("no data", type: .info)
        }
    }
//вытаскиваем по имени
    func updateCategoryGoods() {
        for i in 0...goods.count-1 {
            if goods[i].category == category {
                if goods[i].images.count != 0 {
                categoryGoods.append(Goods(name: goods[i].name, surname: goods[i].surname, phone: goods[i].phone, category: goods[i].category, price: goods[i].price, description: goods[i].description, characteristics: goods[i].characteristics, images: goods[i].images, imageURLs: goods[i].imageURLs))
                }
            }
        }
    }
    
    func navBar() {
        UINavigationBar.appearance().barTintColor = .white
        navigationItem.title = category
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style:.plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "home"), style:.plain, target: self, action: nil)//#selector(CategoryViewController.logoutPressed))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryGoods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HouseCollectionViewCell
        
        cell.imageView.image = categoryGoods[indexPath.row].images[0]
        cell.textLabel.text = "\(String(categoryGoods[indexPath.row].name)) \(String(categoryGoods[indexPath.row].surname))"
        cell.priceLabel.text = categoryGoods[indexPath.row].price
        cell.placeLabel.text = categoryGoods[indexPath.row].description
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newViewController = AboutHouseViewController()
        newViewController.goods = categoryGoods
        newViewController.index = indexPath.row
        navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func setupViews() {
        view.addSubview(welcomeLabel)
        view.addSubview(houseCollectionView)
    }
    func setupFrame() {
        
        welcomeLabel.frame = CGRect(x: view.center.x - (view.frame.width*0.4), y: (view.frame.width*0.08)/3, width: view.frame.width*0.8, height: (view.frame.width*0.08))
        houseCollectionView.frame = CGRect(x: 0, y: welcomeLabel.frame.maxY + (view.frame.width*0.08)/3, width: view.frame.width, height: view.frame.height - (welcomeLabel.frame.maxY + (view.frame.width*0.08)/3))
        
    }
}
