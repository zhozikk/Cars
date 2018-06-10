//
//  LoginView.swift
//  Cars
//
//  Created by Zho on 20.04.2018.
//  Copyright © 2018 Zho. All rights reserved.

import UIKit
import SkyFloatingLabelTextField

@available(iOS 11.0, *)
class LoginViewController: UIViewController {
    
    let authService = AuthenticationService()
    
    let border = CALayer()
    let border2 = CALayer()
    let width = CGFloat(2.0)
    
    private lazy var emailTextField : SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        field.placeholder = "Email"
        
        field.title = "Номер Телефона"
        field.lineHeight = 1.0 // bottom line height in points
        field.selectedLineHeight = 1.0
        field.placeholderColor = .white
        field.tintColor = UIColor.init(red: 94.0/255, green: 87.0/255, blue: 171.0/255, alpha: 1.0)
        field.textColor = .white
        field.lineColor = .white
        field.selectedLineColor = .white
        
        field.layer.masksToBounds = true
        
        field.textColor = .white
        field.textAlignment = .left
        field.clipsToBounds = true
        field.backgroundColor = .clear
        /*
         field.tintColor = UIColor.init(red: 94.0/255, green: 87.0/255, blue: 171.0/255, alpha: 1.0)
         field.textColor = .black
         field.lineColor = .black
         field.selectedLineColor = .black
         
         field.layer.masksToBounds = true
         
         field.textColor = .black
         field.textAlignment = .left
         field.clipsToBounds = true
         field.backgroundColor = .clear
 */
        
        return field
    }()
    
    private lazy var passwordTextField : SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        field.placeholder = "Password"
        field.isSecureTextEntry = true
        
        field.placeholderColor = .white
        field.tintColor = UIColor.init(red: 94.0/255, green: 87.0/255, blue: 171.0/255, alpha: 1.0)
        field.textColor = .white
        field.lineColor = .white
        field.selectedLineColor = .white
        
        field.layer.masksToBounds = true
        
        field.textColor = .white
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
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
        button.setTitleColor(UIColor.init(red: 94.0/255, green: 87.0/255, blue: 171.0/255, alpha: 1.0), for: .normal)
        button.layer.cornerRadius = 20
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.loginPressed))
        button.isUserInteractionEnabled = true
        button.addGestureRecognizer(tap)
        return button
    }()
    
    private lazy var welcomeLabel : UILabel = {
        let label = UILabel()
        label.text = "Добро Пожаловать"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue", size: 25.0)
        return label
    }()
    
    private lazy var ownerLabel : UILabel = {
        let label = UILabel()
        label.text = "арендодатель"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue", size: 12.5)
        return label
    }()
    
    private lazy var signupLabel : UILabel = {
        let label = UILabel()
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.signUpPressed))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        
        label.attributedText = NSAttributedString(string: "У вас нет аккаута? Зарегистрируйтесь!", attributes:
            [.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
        
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue", size: 12.5)
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(self.view.frame.width, self.view.frame.height)

        navBar()
        
        view.backgroundColor = UIColor.init(red: 94.0/255, green: 87.0/255, blue: 171.0/255, alpha: 1.0)
        
        setupViews()
        setupFrame()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        view.addGestureRecognizer(tap)
    }
    
    func navBar() {
        UINavigationBar.appearance().barTintColor = UIColor.init(red: 94.0/255, green: 87.0/255, blue: 171.0/255, alpha: 1.0)//UIColor(displayP3Red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style:.plain, target: self, action: #selector(LoginViewController.menuPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "home"), style:.plain, target: nil, action: nil)
    }
    
    @objc func loginPressed() {
        UINavigationBar.appearance().barTintColor = .white
        let email = emailTextField.text!.lowercased()
        let finalEmail = email.trimmingCharacters(in: CharacterSet.whitespaces)
        let password = passwordTextField.text!
        
        if  password.isEmpty || finalEmail.isEmpty{
            self.view.endEditing(true)
            self.showMessage("please check your text fields", type: .info)
        } else {
            self.showMessage("Загрузка...", type: .info)
            self.view.endEditing(true)
            authService.signIn(finalEmail, password: password, vs: self)
            
        }
    }
    
    @objc func menuPressed() {
        UINavigationBar.appearance().barTintColor = .white
        print("pressed")
        (UIApplication.shared.delegate as? AppDelegate)?.loadMenuPage()
    }
    
    @objc func signUpPressed() {
        UINavigationBar.appearance().barTintColor = .white
        let newViewController = SignUpViewController()
        navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @objc func tapAction() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    
    func setupViews() {
        view.addSubview(welcomeLabel)
        view.addSubview(ownerLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(enterButton)
        view.addSubview(signupLabel)
    }
    
    func setupFrame() {
        
        welcomeLabel.frame = CGRect(x: view.center.x - (view.frame.width*0.335), y: view.frame.width*0.1, width: view.frame.width*0.67, height: view.frame.width*0.06)
        ownerLabel.frame = CGRect(x: view.center.x - (view.frame.width*0.335), y: welcomeLabel.frame.maxY, width: view.frame.width*0.67, height: view.frame.width*0.06)
        emailTextField.frame = CGRect(x: view.center.x - (view.frame.width*0.44), y: ownerLabel.frame.maxY + (view.frame.width*0.1067), width: view.frame.width*0.88, height: view.frame.width*0.09)
        
        passwordTextField.frame = CGRect(x: view.center.x - (view.frame.width*0.44), y: emailTextField.frame.maxY + (view.frame.width*0.1067), width: view.frame.width*0.88, height: view.frame.width*0.09)
        
        enterButton.frame  = CGRect(x: view.center.x - (view.frame.width*0.44), y: passwordTextField.frame.maxY + ((view.frame.width*0.1067)), width: view.frame.width*0.88, height: view.frame.width*0.12)
        
        signupLabel.frame = CGRect(x: enterButton.frame.minX, y: enterButton.frame.maxY + 3, width: view.frame.width*0.88, height: view.frame.width*0.05)
        
        
        let triangle = LoginTriangleView(frame: CGRect(x: 0, y: enterButton.frame.maxY + 40, width: view.frame.width , height: view.frame.height - (enterButton.frame.maxY + 40)))
        triangle.backgroundColor = .white
        view.addSubview(triangle)
    }
    
    
}
