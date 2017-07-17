//
//  MainNavigationController.swift
//  LoginGuide
//
//  Created by 陳 冠禎 on 2017/7/14.
//  Copyright © 2017年 陳 冠禎. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
       
        
        if isLoggedIn() {
            let homeController = HomeController()
            viewControllers = [homeController]
            
        } else {
            perform(#selector(showLoginController), with: nil, afterDelay: 0.01)
            
        }
        
    }
    
    
    fileprivate func isLoggedIn() -> Bool {
        return UserDefaults.standard.isLoggedIn()
    }
    func showLoginController() {
        let loginController = LoginController()
        present(loginController, animated: true, completion: {
            //                code
        })
    }
    
}
