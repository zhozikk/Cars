//
//  LoginView.swift
//  Cars
//
//  Created by Zho on 23.04.2018.
//  Copyright © 2018 Zho. All rights reserved.

import UIKit

class GoodsCollectionViewCell: UICollectionViewCell {
    
    lazy var goodsImageView : UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 10.0
//        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.gray.cgColor
        view.backgroundColor = .white
        view.contentMode = .scaleToFill
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        contentView.addSubview(goodsImageView)
    }
    
    func setupConstraints() {
        goodsImageView.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
