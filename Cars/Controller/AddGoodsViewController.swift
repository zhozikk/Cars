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
import BEMCheckBox

@available(iOS 11.0, *)
@available(iOS 11.0, *)
class AddGoodsViewController: UIViewController {
    
    var databaseRef: DatabaseReference! {
        return Database.database().reference()
    }
    
    var storageRef: StorageReference! {
        
        return Storage.storage().reference()
    }

    
    var indexpath = IndexPath()
    var images = [#imageLiteral(resourceName: "add")]
    var imageUrls = [""]
    var cnt = Int()
    var goods = [Goods]()
    var name = String()
    var surname = String()
    var phone = String()
    
    let authService = AuthenticationService()
    let userID = Auth.auth().currentUser!
    let border = CALayer()
    let width = CGFloat(1.0)
    
    let group = BEMCheckBoxGroup()
    
    private lazy var welcomeLabel : UILabel = {
        let label = UILabel()
        label.text = "Добавление товара"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        
        return label
    }()
    
    private lazy var categoryLabel : UILabel = {
        let label = UILabel()
        label.text = "1) Выберите категорию           Цена"
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = UIColor.init(red: 94.0/255, green: 87.0/255, blue: 171.0/255, alpha: 1.0)
        label.font = UIFont(name: "HelveticaNeue", size: 13.0)
        return label
    }()
    
    lazy var priceTextField : UITextField = {
        let field = UITextField()
        
        field.layer.masksToBounds = true
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.gray.cgColor
        field.textColor = .black
        field.textAlignment = .left
        field.clipsToBounds = true
        field.backgroundColor = .clear
        
        return field
    }()
    
    private lazy var descriptionLabel : UILabel = {
        let label = UILabel()
        label.text = "2) Описание товара"
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = UIColor.init(red: 94.0/255, green: 87.0/255, blue: 171.0/255, alpha: 1.0)
        label.font = UIFont(name: "HelveticaNeue", size: 13.0)
        return label
    }()
    
    lazy var descriptionTextView : UITextView = {
        let view = UITextView()
        view.textColor = .black
        view.font = UIFont(name: "HelveticaNeue", size: 13.0)
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    private lazy var description2Label : UILabel = {
        let label = UILabel()
        label.text = "3)Адрес(улица, район)"
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = UIColor.init(red: 94.0/255, green: 87.0/255, blue: 171.0/255, alpha: 1.0)
        label.font = UIFont(name: "HelveticaNeue", size: 13.0)
        return label
    }()
    
    lazy var description2TextView : UITextView = {
        let view = UITextView()
        view.textColor = .black
        view.font = UIFont(name: "HelveticaNeue", size: 13.0)
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    lazy var addButton : UIButton = {
        let button = UIButton()
        button.sendActions(for: .touchUpInside)
        button.backgroundColor = .white
        button.clipsToBounds = true
        button.setTitle("Добавить", for: .normal)
        button.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
        button.setTitleColor(UIColor.init(red: 94.0/255, green: 87.0/255, blue: 171.0/255, alpha: 1.0), for: .normal)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.black.cgColor
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddGoodsViewController.addPressed))
        button.isUserInteractionEnabled = true
        button.addGestureRecognizer(tap)
        return button
    }()
    private lazy var photoButton : UIButton = {
        let button = UIButton()
        button.sendActions(for: .touchUpInside)
        button.backgroundColor = UIColor.init(red: 94.0/255, green: 87.0/255, blue: 171.0/255, alpha: 1.0)
        button.clipsToBounds = true
        button.setTitle("Прикрепить фото", for: .normal)
        button.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 20
//        button.layer.borderWidth = 1.0
//        button.layer.borderColor = UIColor.black.cgColor
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddGoodsViewController.photoPressed))
        button.isUserInteractionEnabled = true
        button.addGestureRecognizer(tap)
        return button
    }()
    
    lazy var transportCheckbox : BEMCheckBox = {
        let checkbox = BEMCheckBox()
        checkbox.boxType = .square
        checkbox.cornerRadius = 0
        checkbox.tintColor = .gray
        checkbox.onTintColor = .black
        checkbox.onCheckColor = .black
        checkbox.animationDuration = 0.2
        checkbox.lineWidth = 1.0
        return checkbox
    }()
    
    
    lazy var transportLabel : UILabel = {
        let label = UILabel()
        label.text = "Транспорт"
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 10.0)
        return label
    }()
    
    lazy var clothesCheckbox : BEMCheckBox = {
        let checkbox = BEMCheckBox()
        checkbox.boxType = .square
        checkbox.cornerRadius = 0
        checkbox.tintColor = .gray
        checkbox.onTintColor = .black
        checkbox.onCheckColor = .black
        checkbox.animationDuration = 0.2
        checkbox.lineWidth = 1.0
        return checkbox
    }()
    
    lazy var clothesLabel : UILabel = {
        let label = UILabel()
        label.text = "Одежда"
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 10.0)
        return label
    }()
    
    lazy var thingsCheckbox : BEMCheckBox = {
        let checkbox = BEMCheckBox()
        checkbox.boxType = .square
        checkbox.cornerRadius = 0
        checkbox.tintColor = .gray
        checkbox.onTintColor = .black
        checkbox.onCheckColor = .black
        checkbox.animationDuration = 0.2
        checkbox.lineWidth = 1.0
        return checkbox
    }()
    
    lazy var thingsLabel : UILabel = {
        let label = UILabel()
        label.text = "Недвижимость"
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 10.0)
        return label
    }()
    
    lazy var techniquesCheckbox : BEMCheckBox = {
        let checkbox = BEMCheckBox()
        checkbox.boxType = .square
        checkbox.cornerRadius = 0
        checkbox.tintColor = .gray
        checkbox.onTintColor = .black
        checkbox.onCheckColor = .black
        checkbox.animationDuration = 0.2
        checkbox.lineWidth = 1.0
        return checkbox
    }()
    
    lazy var techniquesLabel : UILabel = {
        let label = UILabel()
        label.text = "Техника"
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 10.0)
        return label
    }()
    
    lazy var goodsLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width/5, height: view.frame.height/9)
        layout.sectionInset.left = 20
        layout.sectionInset.right = 20
        layout.minimumLineSpacing = view.frame.width/20
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    lazy var goodsCollectionView : UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: goodsLayout)
        view.delegate = self
        view.dataSource = self
        view.register(GoodsCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.backgroundColor = .white
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        print(self.view.frame.width, self.view.frame.height)
        navBar()
        border.borderColor = UIColor.red.cgColor
        border.borderWidth = 1.0
        priceTextField.layer.addSublayer(border)
        setupViews()
        setupFrame()
        groupCheckBox()
    }
    
    func navBar() {
        
        UINavigationBar.appearance().barTintColor = .white//UIColor.init(red: 94.0/255, green: 87.0/255, blue: 171.0/255, alpha: 1.0)//UIColor(displayP3Red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        navigationItem.title = "Недвижимости"
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style:.plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "home"), style:.plain, target: self, action: #selector(AddGoodsViewController.logoutPressed))
        
    }
    
    func groupCheckBox() {
        group.addCheckBox(toGroup: transportCheckbox)
        group.addCheckBox(toGroup: clothesCheckbox)
        group.addCheckBox(toGroup: techniquesCheckbox)
        group.addCheckBox(toGroup: thingsCheckbox)
        group.selectedCheckBox = transportCheckbox
        group.mustHaveSelection = true
    }
    
    @objc func logoutPressed() {
        print("pressed")
        UserDefaults.standard.set(nil, forKey: "name")
        UserDefaults.standard.set(nil, forKey: "phone")
        authService.logout()
    }
    
    @objc func photoPressed() {
        
    }
    
    func setupViews() {
        
        view.addSubview(welcomeLabel)
        view.addSubview(categoryLabel)
        view.addSubview(priceTextField)
        
        view.addSubview(transportCheckbox)
        view.addSubview(transportLabel)
        view.addSubview(thingsCheckbox)
        view.addSubview(thingsLabel)
        view.addSubview(clothesCheckbox)
        view.addSubview(clothesLabel)
        view.addSubview(techniquesCheckbox)
        view.addSubview(techniquesLabel)
        
        view.addSubview(descriptionLabel)
        view.addSubview(descriptionTextView)
        view.addSubview(description2Label)
        view.addSubview(description2TextView)
        view.addSubview(goodsCollectionView)
        view.addSubview(addButton)
    }
    
    @objc func tapAction() {
        priceTextField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
        description2TextView.resignFirstResponder()
    }
    
    
    
    func setupFrame() {
        
        welcomeLabel.frame = CGRect(x: view.center.x - (view.frame.width*0.4), y: (view.frame.width*0.08)/3, width: view.frame.width*0.8, height: (view.frame.width*0.08))
        categoryLabel.frame = CGRect(x: (view.frame.width*0.04), y: welcomeLabel.frame.maxY + (view.frame.width*0.04), width: (view.frame.width*0.6), height: (view.frame.width*0.05333))
        priceTextField.frame = CGRect(x: categoryLabel.frame.maxX, y: welcomeLabel.frame.maxY + (view.frame.width*0.04), width: (view.frame.width*0.26666), height: (view.frame.width*0.05333))
        
        border.frame = CGRect(x: categoryLabel.frame.maxX, y: priceTextField.frame.size.height - width, width: priceTextField.frame.size.width, height: width)
        
        transportCheckbox.frame = CGRect(x: categoryLabel.frame.minX + (view.frame.width*0.05333), y: categoryLabel.frame.maxY + ((view.frame.width*0.08)/6), width: (view.frame.width*0.05333), height: (view.frame.width*0.05333))
        transportLabel.frame = CGRect(x: transportCheckbox.frame.maxX + ((view.frame.width*0.08)/6), y: categoryLabel.frame.maxY + ((view.frame.width*0.08)/6), width: (view.frame.width*0.26666), height: (view.frame.width*0.05333))
        
        thingsCheckbox.frame = CGRect(x: categoryLabel.frame.minX + ((view.frame.width*0.08)/6)*4, y: transportCheckbox.frame.maxY + ((view.frame.width*0.08)/6), width: (view.frame.width*0.05333), height: (view.frame.width*0.05333))
        thingsLabel.frame = CGRect(x: transportCheckbox.frame.maxX + ((view.frame.width*0.08)/6), y: transportCheckbox.frame.maxY + ((view.frame.width*0.08)/6), width: (view.frame.width*0.26666), height: (view.frame.width*0.05333))
        
        clothesCheckbox.frame = CGRect(x: categoryLabel.frame.minX + ((view.frame.width*0.08)/6)*4, y: thingsCheckbox.frame.maxY + ((view.frame.width*0.08)/6), width: (view.frame.width*0.05333), height: (view.frame.width*0.05333))
        clothesLabel.frame = CGRect(x: transportCheckbox.frame.maxX + ((view.frame.width*0.08)/6), y: thingsCheckbox.frame.maxY + ((view.frame.width*0.08)/6), width: (view.frame.width*0.26666), height: (view.frame.width*0.05333))
        
        techniquesCheckbox.frame = CGRect(x: categoryLabel.frame.minX + (((view.frame.width*0.08)/6)*4), y: clothesCheckbox.frame.maxY + (view.frame.width*0.08/6), width: (view.frame.width*0.05333), height: (view.frame.width*0.05333))
        techniquesLabel.frame = CGRect(x: transportCheckbox.frame.maxX + (view.frame.width*0.08/6), y: clothesCheckbox.frame.maxY + (view.frame.width*0.08/6), width: (view.frame.width*0.2667), height: (view.frame.width*0.05333))
        
        
        descriptionLabel.frame = CGRect(x: (view.frame.width*0.04), y: techniquesCheckbox.frame.maxY + ((view.frame.width*0.08)/6), width: (view.frame.width*0.8), height: (view.frame.width*0.08))
        descriptionTextView.frame = CGRect(x: (view.frame.width*0.0667), y: descriptionLabel.frame.maxY + ((view.frame.width*0.08)/6), width: (view.frame.width*0.8667), height: (view.frame.width*0.24))
        description2Label.frame = CGRect(x: (view.frame.width*0.04), y: descriptionTextView.frame.maxY + ((view.frame.width*0.08)/3), width: (view.frame.width*0.8), height: ((view.frame.width*0.08)/6)*8)
        description2TextView.frame = CGRect(x: (view.frame.width*0.0667), y: description2Label.frame.maxY + ((view.frame.width*0.08)/6), width: (view.frame.width*0.8667), height: (view.frame.width*0.24))
        goodsCollectionView.frame = CGRect(x: (view.frame.width*0.0667), y: description2TextView.frame.maxY + ((view.frame.width*0.08)/6), width: (view.frame.width*0.8667), height: (view.frame.width*0.21333))
        addButton.frame = CGRect(x: (view.frame.width*0.0667), y: goodsCollectionView.frame.maxY + ((view.frame.width*0.08)/6), width: (view.frame.width*0.8667), height: (view.frame.width*0.1334))
    }
}
