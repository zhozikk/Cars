//
//  Goods.swift
//  Cars
//
//  Created by Бекболат Куанышев on 21.04.2018.
//  Copyright © 2018 Bekbolat. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Firebase

class Goods {
    
    var name: String!
    var surname: String!
    var phone: String!
    var category: String!
    var price: String!
    var description: String!
    var characteristics: String!
    var images: [UIImage]!
    var imageURLs: [String]!
    
    init(snapshot: DataSnapshot) {
        let json = JSON(snapshot.value!)
        self.name = json["name"].stringValue
        self.surname = json["surname"].stringValue
        self.phone = json["phone"].stringValue
        self.category = json["category"].stringValue
        self.price = json["price"].stringValue
        self.description = json["description"].stringValue
        self.characteristics = json["characteristics"].stringValue
        self.imageURLs = json["profileImageURLs"].arrayObject as! [String]
    }
    
    init(name: String, surname: String, phone: String, category: String, price: String, description: String, characteristics: String, images: [UIImage], imageURLs: [String]) {
        self.name = name
        self.surname = surname
        self.phone = phone
        self.category = category
        self.price = price
        self.description = description
        self.characteristics = characteristics
        self.images = images
        self.imageURLs = imageURLs
        
    }
    
    var databaseRef: DatabaseReference! {
        return Database.database().reference()
    }
    
    var storageRef: StorageReference! {
        
        return Storage.storage().reference()
    }
    
    func uploadData() {
        let userID = Auth.auth().currentUser?.uid
        let userRef = databaseRef.child("goods").child(category).child(userID!).childByAutoId()
        let newGoodKey = userRef.key
        
        var uploadImageUrls = imageURLs
        var uploadImages = images
        uploadImageUrls?.remove(at: imageURLs.count-1)
        uploadImages?.remove(at: images.count-1)
        
        // Firstly uploading goods model to the database with empty imageURLs as ""
        
        let userInfo = ["name": name, "surname": surname, "phone": phone, "category": category, "price": price, "description": description, "characteristic": characteristics, "profileImageURLs" : uploadImageUrls!] as [String : Any]
        userRef.setValue(userInfo)
        let newImageRef = storageRef.child(userID!)
        
        // Now uploading image to the storage and after will update database imageURLs by taking images url.
        for image in 0...(uploadImages?.count)!-1 {
            if let imageData = UIImageJPEGRepresentation(uploadImages![image], 0.6) {
                
                //upload image to storage
                newImageRef.child("\(category)+\(uploadImages![image])").putData(imageData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                        print("Error")
                    }
                    DispatchQueue.main.async {
                        print("update")
                        // update database imageURLs
                        uploadImageUrls![image] = (metadata?.downloadURL()?.absoluteString)!
                        
                        self.updateUsersGoods(userId: Auth.auth().currentUser!, category: self.category!, listOfURL: uploadImageUrls!, id: newGoodKey)
                        //                        }
                    }
                })
            }
        }
    }
    
    func updateUsersGoods(userId: User, category: String, listOfURL: [String], id: String) {
        let userRef = self.databaseRef.child("goods").child(category).child(userId.uid).child(id)
        userRef.updateChildValues(["profileImageURLs": listOfURL])
    }
}

class GoodsImages {
    var image : UIImage!
    var imageURL: String
    
    init(image: UIImage, imageURL: String) {
        self.image = image
        self.imageURL = imageURL
    }
}
