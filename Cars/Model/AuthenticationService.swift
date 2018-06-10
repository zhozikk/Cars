//
//  AuthService.swift
//  Cars
//
//  Created by Бекболат Куанышев on 19.04.2018.
//  Copyright © 2018 Bekbolat. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import GSMessages

@available(iOS 11.0, *)
@available(iOS 11.0, *)
@available(iOS 11.0, *)
struct AuthenticationService {
    
    var profile = [Profile]()
    
    var databaseRef: DatabaseReference! {
        return Database.database().reference()
    }

    var storageRef: StorageReference! {

        return Storage.storage().reference()
    }


    // 4 - We sign in the User
    func signIn(_ email: String, password: String, vs: UIViewController){
        if email == "" || password == "" {

            vs.showMessage("Check your email or password,please", type: .success)

        } else {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if error == nil {

                    print("You have successfully logged in")
                    (UIApplication.shared.delegate as? AppDelegate)?.loadMainPages()

                } else {
                    if let myError = error?.localizedDescription {
                        print(myError)
                    } else {
                        print("Error")
                    }
                    vs.showMessage("Check your email or password,please", type: .success)
                    
                }
            }
        }

    }
//
    // 1 - We create firstly a New User
    func signUp(_ email: String, password: String, name: String, surname: String, phone: String, vc: UIViewController){
        if email == "" || password == "" {

            vc.showMessage("Check your name,email or password,please", type: .success)

        } else {
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    self.saveInfo(user, name: name, surname: surname, phone: phone)
                    (UIApplication.shared.delegate as? AppDelegate)?.loadMainPages()


                }else {
                    if let myError = error?.localizedDescription {
                        print(myError)
                    } else {
                        print("Error")
                    }
                    vc.showMessage("Check your name,email or password,please", type: .success)
                }
            })
        }
    }
    
    // 2 - We set the User Info
    func saveInfo(_ user: User!, name: String, surname: String, phone: String){
        let userInfo = ["email": user.email!, "name": name, "surname": surname, "phone": phone]

        let userRef = databaseRef.child("users").child(user.uid)

        userRef.setValue(userInfo)
    }

    func logout(){
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                print("LOGOUT SUCCESS")
                
                (UIApplication.shared.delegate as? AppDelegate)?.loadLoginPages()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }

    }
    
    
}


