//
//  LoginView.swift
//  Cars
//
//  Created by Zho on 24.04.2018.
//  Copyright © 2018 Zho. All rights reserved.

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

@available(iOS 11.0, *)
@available(iOS 11.0, *)
class CategoryViewController: UIViewController {

    let authService = AuthenticationService()
    var category = String()
    var goods = [Goods]()
    var index = Int()

//UI
    lazy var searchTextField : UITextField = {
        let field = UITextField()
        field.placeholder = "   Search"
        field.textColor = .black
        field.textAlignment = .left
        field.clipsToBounds = true
        field.layer.cornerRadius = 15
        field.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        field.backgroundColor = .gray
        
        return field
    }()
    
    lazy var categoryLabel : UILabel = {
        let label = UILabel()
        label.text = "Категории"
        label.textColor = .black
        label.font = UIFont(name: "HelveticaNeue-light", size: 18.0)
        return label
    }()
    
    lazy var carsView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
//        view.backgroundColor = .gray
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(CategoryViewController.transportViewPressed))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
        return view
    }()
    
    lazy var carImageView : UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "car")
        view.clipsToBounds = true
        return view
    }()
    
    lazy var carLabel : UILabel = {
        let label = UILabel()
        label.text = "Транспорт"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue-Light", size: 12.0)
        return label
    }()
    
    
    lazy var bicyclesView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
//        view.backgroundColor = .gray
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(CategoryViewController.nedvijimostViewPressed))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
        return view
    }()
    
    lazy var bicycleImageView : UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "drawer")
        view.clipsToBounds = true
        return view
    }()
    
    lazy var bicycleLabel : UILabel = {
        let label = UILabel()
        label.text = "Недвижимость"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue-Light", size: 12.0)
        return label
    }()
    
    lazy var homeView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
//        view.backgroundColor = .gray
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(CategoryViewController.techniquesViewPressed))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
        return view
    }()
    
    lazy var homeImageView : UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "fridge")
        view.clipsToBounds = true
        return view
    }()
    
    lazy var homeLabel : UILabel = {
        let label = UILabel()
        label.text = "Бытовая техника"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue-Light", size: 12.0)
        return label
    }()
    
    lazy var kitchenView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(CategoryViewController.clothesViewPressed))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
        return view
    }()
    
    lazy var kitchenImageView : UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "hoodie")
        view.clipsToBounds = true
        return view
    }()
    
    lazy var kitchenLabel : UILabel = {
        let label = UILabel()
        label.text = "Одежда"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue-Light", size: 12.0)
        return label
    }()
    
    lazy var spinner: UIActivityIndicatorView = {
        let s = UIActivityIndicatorView()
        s.center = self.view.center
        s.frame.size = CGSize(width: 100, height: 100)
        s.startAnimating()
        return s
    }()
//
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(spinner)
        goodsData()
        navBar()
        setupViews()
        setupFrame()
    }

    
    @objc func transportViewPressed() {
        
        if (self.goods.count > 0) {
            UINavigationBar.appearance().barTintColor = .white
            let newViewController = RentHouseViewController()
            newViewController.category = "Транспорт"
            newViewController.goods = self.goods
            navigationController?.pushViewController(newViewController, animated: true)
        }
        
    }
    
    @objc func nedvijimostViewPressed() {
        if (self.goods.count > 0) {
            UINavigationBar.appearance().barTintColor = .white
            let newViewController = RentHouseViewController()
            newViewController.category = "Недвижимость"
            newViewController.goods = self.goods
            navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    @objc func techniquesViewPressed() {
        if (self.goods.count > 0) {
            UINavigationBar.appearance().barTintColor = .white
            let newViewController = RentHouseViewController()
            newViewController.category = "Техника"
            newViewController.goods = self.goods
            navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    @objc func clothesViewPressed() {
        if (self.goods.count > 0) {
            UINavigationBar.appearance().barTintColor = .white
            let newViewController = RentHouseViewController()
            newViewController.category = "Одежда"
            newViewController.goods = self.goods
            navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    func navBar() {
        navigationItem.title = "Tisy"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style:.plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "home"), style:.plain, target: self, action: #selector(checkAuth))
//    }
    }
    @objc func checkAuth() {
        if ((Auth.auth().currentUser) != nil) {
            let nv = ProfileViewController()
            navigationController?.pushViewController(nv, animated: true)
        } else {
            let nv = LoginViewController()
            navigationController?.pushViewController(nv, animated: true)
        }
      
    }
//вытаскваю все с базы
//заполняю по катеогория
    func goodsData() {
        let dbRef = Database.database().reference()
        let categories = ["Транспорт", "Недвижимость", "Одежда", "Техника"]
        for category in categories {
            dbRef.child("goods").child(category).observe(.childAdded) { (snapshot) in
                if snapshot.exists() {
                    print("exits")
                    let dataArray : NSArray = snapshot.children.allObjects as NSArray
                    
                    for child in dataArray {
                        
                        let snap = child as! DataSnapshot
                        if snap.value is NSDictionary {
                            let data : NSDictionary = snap.value as! NSDictionary
                            let profileImages = data.value(forKey: "profileImageURLs") as! [String?]
                            
                            if profileImages[0] != "" {
                                
                                DispatchQueue.main.async {
                                    print("entered")
                                    let category = data.value(forKey: "category") as! String
                                    let price = data.value(forKey: "price") as! String
                                    let description = data.value(forKey: "description")  as! String
                                    let characteristic = data.value(forKey: "characteristic")  as! String
                                    let profileImages = data.value(forKey: "profileImageURLs") as! [String]
                                    let name = data.value(forKey: "name")  as! String
                                    let surname = data.value(forKey: "surname")  as! String
                                    let phone = data.value(forKey: "phone")  as! String
                                    self.index += 1
                                    self.addToModel(name: name, surname: surname, phone: phone, category: category, price: price, description: description, characteristics: characteristic, images: profileImages, index: self.index)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    func addToModel(name: String, surname: String, phone: String, category: String, price: String, description: String, characteristics: String, images: [String], index: Int) {
        
        goods.append(Goods(name: name, surname: surname, phone: phone, category: category, price: price, description: description, characteristics: characteristics, images: [], imageURLs: images))
        
        print("downaload call")
        for i in 0...images.count-1 {
            print(images[i])
            let imagesURL = images[i]
            if (imagesURL != "") {
                let url: URL = URL(string: imagesURL)!
                let session = URLSession.shared
                let task = session.dataTask(with: url) { (data, respose, error) in
                    if data != nil {
                        let image = UIImage(data: data!)
                        if image != nil {
                            DispatchQueue.main.async(execute: {
                                self.goods[index-1].images.append(image!)
                            })
                        }
                    }
                }
                task.resume()
            }
        }
    }
    
//

//добавляешь на вью
    func setupViews() {
        view.addSubview(categoryLabel)
        view.addSubview(carsView)
        view.addSubview(carImageView)
        view.addSubview(carLabel)
        view.addSubview(bicyclesView)
        view.addSubview(bicycleImageView)
        view.addSubview(bicycleLabel)
        view.addSubview(homeView)
        view.addSubview(homeImageView)
        view.addSubview(homeLabel)
        view.addSubview(kitchenView)
        view.addSubview(kitchenImageView)
        view.addSubview(kitchenLabel)
    }
//констрайнс
    func setupFrame() {
        
        categoryLabel.frame = CGRect(x: self.view.frame.minX + 48, y: self.view.frame.minY + 32, width: 200, height: 30)
        
        carsView.frame = CGRect(x: self.view.frame.minX + 48, y: self.view.frame.minY + 128, width: 150, height: 150)
        carImageView.frame = CGRect(x: carsView.center.x - 25, y: carsView.frame.minY + 20, width: 50, height: 50)
        carLabel.frame = CGRect(x: carsView.frame.minX, y: carImageView.frame.maxY + 10, width: carsView.frame.width, height: 50)
        
        bicyclesView.frame = CGRect(x: self.carsView.frame.maxX + 32, y: self.view.frame.minY + 128, width: 150, height: 150)
        bicycleImageView.frame = CGRect(x: bicyclesView.center.x - 25, y: bicyclesView.frame.minY + 20, width: 50, height: 50)
        bicycleLabel.frame = CGRect(x: bicyclesView.frame.minX, y: bicycleImageView.frame.maxY + 10, width: bicyclesView.frame.width, height: 50)
        
        homeView.frame = CGRect(x: self.view.frame.minX + 48, y: self.carsView.frame.maxY + 32, width: 150, height: 150)
        homeImageView.frame = CGRect(x: homeView.center.x - 25, y: homeView.frame.minY + 20, width: 50, height: 50)
        homeLabel.frame = CGRect(x: homeView.frame.minX, y: homeImageView.frame.maxY + 10, width: homeView.frame.width, height: 50)
        
        kitchenView.frame = CGRect(x: self.homeView.frame.maxX + 32, y: self.carsView.frame.maxY + 32, width: 150, height: 150)
        kitchenImageView.frame = CGRect(x: kitchenView.center.x - 25, y: kitchenView.frame.minY + 20, width: 50, height: 50)
        kitchenLabel.frame = CGRect(x: kitchenView.frame.minX, y: kitchenImageView.frame.maxY + 10, width: kitchenView.frame.width, height: 50)
        
        let triangle = SignUpTriangleView(frame: CGRect(x: 0, y: self.view.frame.maxY - view.frame.height/3 , width: view.frame.width/2, height: view.frame.height/3))
        triangle.backgroundColor = .white
        view.addSubview(triangle)
    }


}

