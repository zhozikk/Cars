//
//  LoginView.swift
//  Cars
//
//  Created by Zho on 23.04.2018.
//  Copyright © 2018 Zho. All rights reserved.

import Foundation
import UIKit

@available(iOS 11.0, *)
class HouseCollectionViewCell: UICollectionViewCell {

    let border = CALayer()
    let width = CGFloat(1.0)
    
    lazy var textLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 14.0)
        return label
    }()
    lazy var priceLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(red: 94.0/255, green: 87.0/255, blue: 171.0/255, alpha: 1.0)
        label.font = UIFont(name: "HelveticaNeue", size: 12.0)
        return label
    }()
    lazy var placeLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 12.0)
        return label
    }()
    
    @available(iOS 11.0, *)
    lazy var imageView : UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 10.0
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = .gray
        view.contentMode = .scaleToFill
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(textLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(placeLabel)

        border.backgroundColor = UIColor.gray.cgColor
        border.frame = CGRect(x: 0, y: contentView.frame.size.height - width, width: contentView.frame.size.width, height: width)
        contentView.layer.addSublayer(border)
        
    }
    
    func setupConstraints() {
        imageView.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height/1.4)
        textLabel.frame = CGRect(x: 0, y: imageView.frame.maxY + 15, width: contentView.frame.width, height: 20)
        priceLabel.frame = CGRect(x: 0, y: textLabel.frame.maxY + 5, width: contentView.frame.width, height: 15)
        placeLabel.frame = CGRect(x: 0, y: priceLabel.frame.maxY, width: contentView.frame.width, height: 20)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
