//
//  LoginView.swift
//  Cars
//
//  Created by Zho on 23.04.2018.
//  Copyright © 2018 Zho. All rights reserved.


import Foundation
import UIKit
import Firebase

class ProfileCollectionViewCell: UICollectionViewCell {
    
    lazy var imageView : UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
//        view.layer.cornerRadius = 10.0
//        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner]
//        view.backgroundColor = .gray
        view.contentMode = .scaleToFill
        return view
    }()
    
    var good : Goods! {
        didSet {
            self.setupViews()
            self.setupConstraints()
            self.receiveData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
        
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.black.cgColor
    }
    
    func receiveData() {
        
        //        if let imageURL = good.imageURLs[0] {
        if good.imageURLs[0] != "" {
            let imageStorage = Storage.storage().reference(forURL: good.imageURLs[0])
            imageStorage.getData(maxSize: 1024*1024, completion: { [weak self] (data, error) in
                if let err = error {
                    print("Error accures --->  \(err)")
                } else {
                    if let imageData = data {
                        DispatchQueue.main.async {
                            let image = UIImage(data: imageData)
                            self?.imageView.image = image
                        }
                    }
                }
            })
        }
    }
    
    func setupViews() {
        contentView.addSubview(imageView)
    }
    
    func setupConstraints() {
        imageView.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
