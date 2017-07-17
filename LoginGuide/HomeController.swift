//
//  HomeController.swift
//  LoginGuide
//
//  Created by 陳 冠禎 on 2017/7/14.
//  Copyright © 2017年 陳 冠禎. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "home")
        return iv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "We're logged in"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign out",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(handleSignOut))
        
        view.addSubview(imageView)
        _ = imageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 64, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        
    }
    
    func handleSignOut() {
        UserDefaults.standard.setIsLoggedIn(value: false)
        
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
        
    }
    
}
