//
//  LoginView.swift
//  Cars
//
//  Created by Zho on 20.04.2018.
//  Copyright © 2018 Zho. All rights reserved.

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

@available(iOS 11.0, *)
class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let authService = AuthenticationService()
    let userId = Auth.auth().currentUser!
    var profile = [Profile]()
    var goods = [Goods]()
    var goodsImages = [GoodsImages]()
    var count = 0
    var index = Int()
    
    private lazy var welcomeLabel : UILabel = {
        let label = UILabel()
        label.text = "Личный кабинет"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        return label
    }()
    
    private lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont(name: "HelveticaNeue", size: 14.0)
        return label
    }()
    
    private lazy var phoneLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont(name: "HelveticaNeue", size: 14.0)
        return label
    }()
    
    private lazy var goodsLabel : UILabel = {
        let label = UILabel()
        label.text = "Ваши товары"
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        return label
    }()
    
    private lazy var addButton : UIButton = {
        let button = UIButton()
        button.sendActions(for: .touchUpInside)
        button.backgroundColor = .white
        button.clipsToBounds = true
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        button.setTitleColor(.gray, for: .normal)
        let tap = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.addPressed))
        button.isUserInteractionEnabled = true
        button.addGestureRecognizer(tap)
        return button
    
    }()
    
    private lazy var profileLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width/2.6, height: view.frame.width/2.6)
        layout.sectionInset.left = 30
        layout.sectionInset.right = 30
        layout.sectionInset.bottom = view.frame.width/5
        layout.minimumLineSpacing = view.frame.width/18
        layout.scrollDirection = .vertical
        return layout
    }()
    
    private lazy var houseCollectionView : UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: profileLayout)
        view.delegate = self
        view.dataSource = self
        view.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.backgroundColor = .white
        return view
    }()
    lazy var actIn: UIActivityIndicatorView = {
        let actInd = UIActivityIndicatorView()
        actInd.frame = CGRect(x:0,y: 0,width: 40,height: 40)
        actInd.color = .black
        actInd.center = CGPoint(x: self.view.frame.size.width / 2,
                                y:self.view.frame.size.height / 2)
        actInd.startAnimating()
        return actInd
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        print(self.view.frame.width, self.view.frame.height)
        navBar()
        setupViews()
        setupFrame()
        personalData()
        alternativeReceiveData()
        self.perform(#selector(ProfileViewController.hideActivityIndicatory), with: nil, afterDelay: 10.0)
    }
    
    func navBar() {
        UINavigationBar.appearance().barTintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style:.plain, target: self, action: #selector(ProfileViewController.menuPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "exit"), style:.plain, target: self, action: #selector(ProfileViewController.logoutPressed))
        
    }
    
    @objc func menuPressed() {
        let newViewController = CategoryViewController()
        navigationController?.pushViewController(newViewController, animated: true) 
    }
    
    
    func alternativeReceiveData() {
     
         let userId = Auth.auth().currentUser
         let dbRef = Database.database().reference()
         // for data under Транспорт
         let categories = ["Транспорт", "Недвижимость", "Одежда", "Техника"]
         for category in categories {
             dbRef.child("goods").child(category).child((userId?.uid)!).observe(.childAdded) { (snapshot) in
                
                DispatchQueue.main.async {
                    let newGoods = Goods(snapshot: snapshot)
                    self.goods.insert(newGoods, at: 0)
                    let indexPath = IndexPath(item: 0, section: 0)
                    self.houseCollectionView.insertItems(at: [indexPath])
                }
                
            }
         }
     }
    
    
    func personalData() {
        let phone = UserDefaults.standard.value(forKey: "phone") as? String
        let name = UserDefaults.standard.value(forKey: "name") as? String
        if (name == nil && phone == nil) {
            receiveData()
        } else {
            nameLabel.text = name
            phoneLabel.text = phone
        }
    }

    @objc func hideActivityIndicatory(uiView: UIView) {
        actIn.isHidden = true
    }
    
    @objc func addPressed() {
        let newViewController = AddGoodsViewController()
        let phone = UserDefaults.standard.value(forKey: "phone") as? String
        let name = UserDefaults.standard.value(forKey: "name") as? String
        let surname = UserDefaults.standard.value(forKey: "surname") as? String
        newViewController.name = name!
        newViewController.surname = surname!
        newViewController.phone = phone!
        navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func receiveData() {
        let dbRef = Database.database().reference()
        print(userId)
        dbRef.child("users").queryOrderedByKey().observe(.childAdded, with: {
            snapshot in
            let snapshotValue = snapshot.value as? NSDictionary
            let name = snapshotValue?["name"] as? String
            let surname = snapshotValue?["surname"] as? String
            let phone = snapshotValue?["phone"] as? String
            let email = snapshotValue?["email"] as? String
            if (email == self.userId.email) {
                DispatchQueue.main.async {
                    UserDefaults.standard.set(name, forKey: "name")
                    UserDefaults.standard.set(surname, forKey: "surname")
                    UserDefaults.standard.set(phone, forKey: "phone")
                    self.nameLabel.text = name
                    self.phoneLabel.text = phone
                    self.profile.append(Profile(name: name!, surname: surname!, phone: phone!))
                    print("Added")
                }
            }
        })
    }
    
    @objc func logoutPressed() {
        print("pressed")
        UserDefaults.standard.set(nil, forKey: "name")
        UserDefaults.standard.set(nil, forKey: "phone")
        UINavigationBar.appearance().barTintColor = UIColor.init(red: 94.0/255, green: 87.0/255, blue: 171.0/255, alpha: 1.0)
        authService.logout()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProfileCollectionViewCell
        
        if goods[indexPath.row].imageURLs[0] != "" {
            cell.good = self.goods[indexPath.row]
            return cell
        } else {
            print("empty")
            return cell
        }
        
    }
    
    func setupViews() {
        view.addSubview(welcomeLabel)
        view.addSubview(nameLabel)
        view.addSubview(phoneLabel)
        view.addSubview(goodsLabel)
        view.addSubview(addButton)
        view.addSubview(houseCollectionView)
        view.addSubview(actIn)
    }
    func setupFrame() {
        welcomeLabel.frame = CGRect(x: view.center.x - (view.frame.width*0.4), y: (view.frame.width*0.08)/3, width: view.frame.width*0.8, height: (view.frame.width*0.08))
        nameLabel.frame = CGRect(x: view.center.x - (view.frame.width*0.4), y: welcomeLabel.frame.maxY + 5, width: view.frame.width*0.8, height: (view.frame.width*0.08))
        phoneLabel.frame = CGRect(x: view.center.x - (view.frame.width*0.4), y: nameLabel.frame.maxY, width: view.frame.width*0.8, height: (view.frame.width*0.08))
        goodsLabel.frame = CGRect(x: (view.frame.width*0.08), y: phoneLabel.frame.maxY + (view.frame.width*0.08)/3, width: (view.frame.width*0.333), height: (view.frame.width*0.08))
        addButton.frame = CGRect(x: goodsLabel.frame.maxX, y: phoneLabel.frame.maxY + (view.frame.width*0.08)/3, width: (view.frame.width*0.08), height: (view.frame.width*0.08))
        houseCollectionView.frame = CGRect(x: 0, y: goodsLabel.frame.maxY + (view.frame.width*0.08)/3, width: view.frame.width, height: view.frame.height - (goodsLabel.frame.maxY + (view.frame.width*0.08)/3))
        
    }
}
