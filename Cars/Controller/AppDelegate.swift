//
//  LoginView.swift
//  Cars
//
//  Created by Zho on 20.04.2018.
//  Copyright © 2018 Zho. All rights reserved.

import UIKit
import Firebase
import FirebaseAuth


@available(iOS 11.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        window = UIWindow(frame: UIScreen.main.bounds)
        coordinateAppFlow()
        setupWindow()

        return true
    }
    func coordinateAppFlow() {
        if ((Auth.auth().currentUser) != nil) {
            loadMainPages()
        } else {
            loadLoginPages()
        }
    }
    
    func setupWindow(){
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.gray]
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = .white//UIColor.init(red: 94.0/255, green: 87.0/255, blue: 171.0/255, alpha: 1.0)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().tintColor = .black
        
    }
    
    func loadMainPages() {
        UINavigationBar.appearance().barTintColor = .white
        let homeViewController = UINavigationController(rootViewController: ProfileViewController())
        homeViewController.view.backgroundColor = UIColor.white
        window?.rootViewController = homeViewController
        window?.makeKeyAndVisible()
    }
    
    func loadMenuPage() {
        let homeViewController = UINavigationController(rootViewController: CategoryViewController())
        homeViewController.view.backgroundColor = UIColor.white
        window?.rootViewController = homeViewController
        window?.makeKeyAndVisible()
    }
    
    func loadLoginPages() {
        let homeViewController = UINavigationController(rootViewController: LoginViewController())
        window?.rootViewController = homeViewController
        window?.makeKeyAndVisible()
    }

}

