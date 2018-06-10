//
//  LoginView.swift
//  Cars
//
//  Created by Zho on 24.04.2018.
//  Copyright © 2018 Zho. All rights reserved.

import UIKit
import iCarousel

@available(iOS 11.0, *)
class AboutHouseViewController: UIViewController, iCarouselDelegate, iCarouselDataSource {
    
    let authService = AuthenticationService()
    var category = String()
    var goods = [Goods]()
    var index = Int()
    var test = [1,2,3,4,5]
    
    private lazy var welcomeLabel : UILabel = {
        let label = UILabel()
        label.text = "Возможно,это то что вам нужно"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont(name: "Helvetica-Regular", size: 16.0)
        return label
    }()
    
    lazy var textLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 14.0)
        return label
    }()
    lazy var priceLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(red: 94.0/255, green: 87.0/255, blue: 171.0/255, alpha: 1.0)
        label.font = UIFont(name: "Helvetica-Bold", size: 14.0)
        return label
    }()
    
    lazy var placeLabel : UITextView = {
        let label = UITextView()
        label.font = UIFont(name: "Helvetica", size: 14.0)
        label.isEditable = false
        label.textAlignment = .left
        return label
    }()
    
    lazy var phoneLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: 14.0)
        return label
    }()
    
    lazy var descriptionLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: "Helvetica", size: 14.0)
        return label
    }()
    
    lazy var imageView : UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 10.0
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = .gray
        view.contentMode = .scaleToFill
        return view
    }()
    
    private lazy var carouselView : iCarousel = {
        let carouselView = iCarousel()
        carouselView.delegate = self
        carouselView.dataSource = self
        carouselView.type = .linear
//        carouselView.perspective = 2.0
        carouselView.isPagingEnabled = true
//        carouselView.backgroundColor = UIColor.blue
        return carouselView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        print(self.view.frame.width, self.view.frame.height)
        setupViews()
        setupFrame()
        showView()
    }
    
    func showView() {
        textLabel.text = "\(String(goods[index].name)) \(String(goods[index].surname))"
        priceLabel.text = "\(String(goods[index].price)) час/в день"
        placeLabel.text = goods[index].description
        phoneLabel.text = goods[index].phone
        descriptionLabel.text = goods[index].characteristics
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return goods[index].images.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        view.backgroundColor = .red
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        imageView.image = goods[self.index].images[index]
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 1
        view.addSubview(imageView)
        return view
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == iCarouselOption.spacing {
            return value * 1.1
        }
        return value
    }

    func setupViews() {
        
        view.addSubview(welcomeLabel)
        view.addSubview(carouselView)
        view.addSubview(textLabel)
        view.addSubview(priceLabel)
        view.addSubview(placeLabel)
        view.addSubview(phoneLabel)
        view.addSubview(descriptionLabel)
//        view.addSubview(houseCollectionView)
    }
    func setupFrame() {
        
        welcomeLabel.frame = CGRect(x: view.center.x - (view.frame.width*0.4), y: (view.frame.width*0.08)/3, width: view.frame.width*0.8, height: (view.frame.width*0.08))
        carouselView.frame = CGRect(x: 0, y: welcomeLabel.frame.maxY + 10, width: view.frame.width, height: view.frame.height/3)
        textLabel.frame = CGRect(x: self.view.frame.minX + 17, y: self.carouselView.frame.maxY + 8, width: 300, height: 14)
        priceLabel.frame = CGRect(x: self.view.frame.minX + 17, y: self.textLabel.frame.maxY + 8, width: 200, height: 14)
        descriptionLabel.frame = CGRect(x: self.view.frame.minX + 17, y: self.priceLabel.frame.maxY + 8, width: self.view.frame.width - 16, height: 14)
        phoneLabel.frame = CGRect(x: self.view.frame.minX + 17, y: self.descriptionLabel.frame.maxY + 8, width: self.view.frame.width - 16, height: 14)
        placeLabel.frame = CGRect(x: self.view.frame.minX + 16, y: self.phoneLabel.frame.maxY + 8, width: self.view.frame.width - 16, height: 100)
    }
}
