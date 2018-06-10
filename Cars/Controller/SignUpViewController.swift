//
//  LoginView.swift
//  Cars
//
//  Created by Zho on 20.04.2018.
//  Copyright © 2018 Zho. All rights reserved.

import Foundation
import UIKit
import SkyFloatingLabelTextField

@available(iOS 11.0, *)
class SignUpViewController: UIViewController {
    
    let authService = AuthenticationService()
    
    private lazy var welcomeLabel : UILabel = {
        let label = UILabel()
        label.text = "Регистрация"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont(name: "HelveticaNeue", size: 20.0)
        return label
    }()
    
    private lazy var emailTextField : SkyFloatingLabelTextField = {
        
        let field = SkyFloatingLabelTextField()
        field.placeholder = "email"
        
        field.title = "email"
        field.lineHeight = 1.0 // bottom line height in points
        field.selectedLineHeight = 1.0
        field.placeholderColor = .gray
        field.tintColor = UIColor.init(red: 94.0/255, green: 87.0/255, blue: 171.0/255, alpha: 1.0)
        field.textColor = .black
        field.lineColor = .black
        field.selectedLineColor = .black
        
        field.layer.masksToBounds = true
        
        field.textColor = .black
        field.textAlignment = .left
        field.clipsToBounds = true
        field.backgroundColor = .clear
        
        return field
    }()
    
    private lazy var nameTextField : SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        field.placeholder = "Имя"
        
        field.title = "Имя"
        field.lineHeight = 1.0 // bottom line height in points
        field.selectedLineHeight = 1.0
        field.placeholderColor = .gray
        field.tintColor = UIColor.init(red: 94.0/255, green: 87.0/255, blue: 171.0/255, alpha: 1.0)
        field.textColor = .black
        field.lineColor = .black
        field.selectedLineColor = .black
        
        field.layer.masksToBounds = true

        
        field.textColor = .black
        field.textAlignment = .left
        field.clipsToBounds = true
        field.backgroundColor = .clear
        
        return field
    }()
    
    private lazy var surnameTextField : SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        field.placeholder = "Фамилия"
        
        field.title = "Фамилия"
        field.lineHeight = 1.0 // bottom line height in points
        field.selectedLineHeight = 1.0
        field.placeholderColor = .gray
        field.tintColor = UIColor.init(red: 94.0/255, green: 87.0/255, blue: 171.0/255, alpha: 1.0)
        field.textColor = .black
        field.lineColor = .black
        field.selectedLineColor = .black
        
        
        field.layer.masksToBounds = true
        
        field.textColor = .black
        field.textAlignment = .left
        field.clipsToBounds = true
        field.backgroundColor = .clear
        
        return field
    }()
    
    private lazy var phoneTextField : SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        field.placeholder = "Номер Телефона"
        
        field.title = "Номер Телефона"
        field.lineHeight = 1.0 // bottom line height in points
        field.selectedLineHeight = 1.0
        field.placeholderColor = .gray
        field.tintColor = UIColor.init(red: 94.0/255, green: 87.0/255, blue: 171.0/255, alpha: 1.0)
        field.textColor = .black
        field.lineColor = .black
        field.selectedLineColor = .black
        
        field.layer.masksToBounds = true
        
        field.textColor = .black
        field.textAlignment = .left
        field.clipsToBounds = true
        field.backgroundColor = .clear
        
        return field
    }()
    
    private lazy var passwordTextField : SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        field.placeholder = "Пароль"
        field.isSecureTextEntry = true
        
        field.lineHeight = 1.0 // bottom line height in points
        field.selectedLineHeight = 1.0
        field.placeholderColor = .gray
        field.tintColor = UIColor.init(red: 94.0/255, green: 87.0/255, blue: 171.0/255, alpha: 1.0)
        field.textColor = .black
        field.lineColor = .black
        field.selectedLineColor = .black
        
        field.layer.masksToBounds = true
        
        field.textColor = .black
        field.textAlignment = .left
        field.clipsToBounds = true
        field.backgroundColor = .clear
        
        return field
    }()
    
    
    private lazy var enterButton : UIButton = {
        let button = UIButton()
        button.sendActions(for: .touchUpInside)
        button.backgroundColor = .white
        button.clipsToBounds = true
        button.setTitle("Зарегистрироваться", for: .normal)
        button.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
        button.setTitleColor(UIColor.init(red: 94.0/255, green: 87.0/255, blue: 171.0/255, alpha: 1.0), for: .normal)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.black.cgColor
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.signUpPressed))
        button.isUserInteractionEnabled = true
        button.addGestureRecognizer(tap)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        print(self.view.frame.width, self.view.frame.height)
        
//        navigationItem.title = "Регистрация"
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style:.plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "home"), style:.plain, target: nil, action: nil)
        
        setupViews()
        setupFrame()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        view.addGestureRecognizer(tap)
    }
    
    @objc func tapAction() {
        nameTextField.resignFirstResponder()
        surnameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @objc func signUpPressed() {
        let email = emailTextField.text!.lowercased()
        let finalEmail = email.trimmingCharacters(in: CharacterSet.whitespaces)
        let password = passwordTextField.text!
        
        if  password.isEmpty || finalEmail.isEmpty{
            self.view.endEditing(true)
            self.showMessage("please check your text fields", type: .info)
        } else {
            self.showMessage("Загрузка...", type: .info)
            self.view.endEditing(true)
            authService.signUp(finalEmail, password: password, name: nameTextField.text!, surname: surnameTextField.text!, phone: phoneTextField.text!, vc: self)
        }
    }
    
    func setupViews() {
        view.addSubview(welcomeLabel)
        view.addSubview(emailTextField)
        view.addSubview(nameTextField)
        view.addSubview(surnameTextField)
        view.addSubview(phoneTextField)
        view.addSubview(passwordTextField)
        view.addSubview(enterButton)
    }
    
    func setupFrame() {

        welcomeLabel.frame = CGRect(x: view.center.x - (view.frame.width*0.335), y: view.frame.width*0.12, width: view.frame.width*0.67, height: view.frame.width*0.09)
        
        emailTextField.frame = CGRect(x: view.center.x - (view.frame.width*0.44), y: welcomeLabel.frame.maxY + view.frame.width*0.08, width: view.frame.width*0.88, height: view.frame.width*0.08)
        
        passwordTextField.frame = CGRect(x: view.center.x - (view.frame.width*0.44), y: emailTextField.frame.maxY + view.frame.width*0.08, width: view.frame.width*0.88, height: view.frame.width*0.08)
        
        nameTextField.frame = CGRect(x: view.center.x - (view.frame.width*0.44), y: passwordTextField.frame.maxY + view.frame.width*0.08, width: view.frame.width*0.88, height: view.frame.width*0.08)
        surnameTextField.frame = CGRect(x: view.center.x - (view.frame.width*0.44), y: nameTextField.frame.maxY + view.frame.width*0.08, width: view.frame.width*0.88, height: view.frame.width*0.08)
        phoneTextField.frame = CGRect(x: view.center.x - (view.frame.width*0.44), y: surnameTextField.frame.maxY + view.frame.width*0.08, width: view.frame.width*0.88, height: view.frame.width*0.08)
        
        enterButton.frame  = CGRect(x: view.center.x - (view.frame.width*0.44), y: phoneTextField.frame.maxY + view.frame.width*0.13, width: (view.frame.width*0.88), height: view.frame.width*0.13)
        
        
        let triangle = SignUpTriangleView(frame: CGRect(x: 0, y: enterButton.frame.maxY + 30, width: view.frame.width/2 , height: view.frame.height - (enterButton.frame.maxY + 30)))
        triangle.backgroundColor = .white
        view.addSubview(triangle)
    }
    
    
}
