//
//  extension.swift
//  Cars
//
//  Created by Бекболат Куанышев on 21.04.2018.
//  Copyright © 2018 Bekbolat. All rights reserved.
//

import Foundation
import UIKit
import Firebase

@available(iOS 11.0, *)
extension AddGoodsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GoodsCollectionViewCell
        cell.goodsImageView.image = images[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        _ = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GoodsCollectionViewCell
        self.indexpath = indexPath
        handleSelectGoodsImageView()
    }
    
    func handleSelectGoodsImageView() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker = UIImage()
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker as? UIImage {
            images[indexpath.row] = selectedImage
            if (indexpath.row == images.count-1) {
                images.append(#imageLiteral(resourceName: "add"))
                imageUrls.append("")
            }
            print (images.count)
            goodsCollectionView.reloadData()
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addPressed() {
        
        let price = priceTextField.text!
        let description = descriptionTextView.text!
        let characteristics = description2TextView.text!
        var category = String()
        switch(group.selectedCheckBox!) {
        case transportCheckbox:
            category = transportLabel.text!
        case thingsCheckbox:
            category = thingsLabel.text!
        case clothesCheckbox:
            category = clothesLabel.text!
        case techniquesCheckbox:
            category = techniquesLabel.text!
        default:
            category = ""
        }
        
        if  price.isEmpty || description.isEmpty || characteristics.isEmpty || images.count == 1{
            self.view.endEditing(true)
            self.showMessage("All fields must be filled: price, desription, characteristics, image", type: .info)
        } else {
            self.showMessage("Loading", type: .info)
            print(images.count)
            print("\(images.count) -> images")
            print("\(imageUrls.count) -> images")
            let newgood = Goods(name: name, surname: surname, phone: phone, category: category, price: price, description: description, characteristics: characteristics, images: images, imageURLs: imageUrls)
            newgood.uploadData()
            let newViewController : UINavigationController = self.navigationController!
            newViewController.popViewController(animated: true)
        }
    }
    
    func addGoods(userID: User, category: String, price: String, description: String, characteristics: String, images: [UIImage], imageUrls: [String],  name: String, surname: String, phone: String) {
        // Firstly I upload data to database, with emty list of ImageUrls
        var uploadImageUrls = imageUrls
        var uploadImages = images
        uploadImageUrls.remove(at: imageUrls.count-1)
        uploadImages.remove(at: images.count-1)
        
        let userInfo = ["name": name, "surname": surname, "phone": phone, "category": category, "price": price, "description": description, "characteristic": characteristics, "profileImageURLs" : uploadImageUrls] as [String : Any]
        let userRef = self.databaseRef.child("goods").child(category).child(userID.uid).childByAutoId()
        let autoId = userRef.key
        userRef.setValue(userInfo)
        
        //Now I'm one by one upload image to the storage and database by updating UPLOADED data with calling function updateUsersGoods().
        
        for image in 0...uploadImages.count-1 {
            if let imageData = UIImageJPEGRepresentation(uploadImages[image], 0.4) {
                
                //upload image to storage
                storageRef.child(userID.uid).child("\(category)+\(uploadImages[image])").putData(imageData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                        print("Error")
                    }
                    if let goodsImageUrl = metadata?.downloadURL()?.absoluteString {
                        DispatchQueue.main.async {
                            print("update")
                            if goodsImageUrl != "" {
                                uploadImageUrls[image] = goodsImageUrl
                                self.updateUsersGoods(userId: userID, category: category, listOfURL: uploadImageUrls, id: autoId)
                            } else {
                                self.deleteUsersGoods(userId: userID, category: category, listOfURL: uploadImageUrls, id: autoId)
                            }
                        }
                        
                    }
                })
            }
        }
    }
    
    func updateUsersGoods(userId: User, category: String, listOfURL: [String], id: String) {
        let userRef = databaseRef.child("goods").child(category).child(userId.uid).child(id)
        userRef.updateChildValues(["profileImageURLs": listOfURL])
    }
    
    func deleteUsersGoods(userId: User, category: String, listOfURL: [String], id: String) {
        let userRef = databaseRef.child("goods").child(category).child(userId.uid).child(id)
        userRef.removeValue()
    }
    
}
