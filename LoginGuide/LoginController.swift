//
//  ViewController.swift
//  LoginGuide
//
//  Created by 陳 冠禎 on 2017/7/14.
//  Copyright © 2017年 陳 冠禎. All rights reserved.
//

import UIKit

protocol LoginDelegate: class {
    func finishLoggingIn()
}

class LoginController: UIViewController, LoginDelegate {
    
    let cellid = "cellid"
    let loginid = "loginid"
    var pageControllerBottomAnchor: NSLayoutConstraint?
    var nextButtonBottomAnchor: NSLayoutConstraint?
    var skipButtonBottomAnchor: NSLayoutConstraint?
    
    lazy var collectView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    
    
    lazy var pageController: UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = .lightGray
        pc.numberOfPages = self.pages.count + 1
        pc.currentPageIndicatorTintColor = UIColor(colorLiteralRed: 247/255, green: 154/255, blue: 27/255, alpha: 1)
        return pc
    }()
    
    lazy var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(UIColor(colorLiteralRed: 247/255, green: 154/255, blue: 27/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(skipButtonPress), for: .touchUpInside)
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.setTitleColor(UIColor(colorLiteralRed: 247/255, green: 154/255, blue: 27/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        return button
    }()
    
    
    
    func nextPage() {
        if pageController.currentPage == pages.count {
            return
        }
        if pageController.currentPage == pages.count - 1 {
            moveController()
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        print("next")
        
        let indexPath = IndexPath(item: pageController.currentPage + 1, section: 0)
        collectView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageController.currentPage += 1
    }
    
    
    
    
    func skipButtonPress() {
        pageController.currentPage = pages.count - 1
        nextPage()
    }
    
    
    let pages: [Page] = {
        let firstPage = Page(title: "Share a great listen", message: "It's free to send your books to the people in your life. Every recipient's first book is on us.", imageName: "page1")
        
        let secondPage = Page(title: "Send from your library", message: "Tap the More menu next to any book. Choose \"Send this book\"", imageName: "page2")
        
        let thirdPage = Page(title: "Send from the player", message: "Tap the More menu in the upper corner Choose \"Send this book\"", imageName: "page3")
        
        return [firstPage, secondPage, thirdPage]
    }()
    
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        collectView.collectionViewLayout.invalidateLayout()
        
        let indexPath = IndexPath(item: pageController.currentPage, section: 0)
        
        DispatchQueue.main.async {
            self.collectView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.collectView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.addSubview(collectView)
        view.addSubview(pageController)
        view.addSubview(skipButton)
        view.addSubview(nextButton)
        // autolayout
        observeKeyboardNotifications()
        
        
        pageControllerBottomAnchor = pageController.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)[1]
        
        skipButtonBottomAnchor = skipButton.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 50).first
        
        nextButtonBottomAnchor = nextButton.anchor(view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 50).first
        
        collectView.anchorToTop(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        registerSetup()
    }
    
    private func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: .UIKeyboardWillHide, object: nil)
        
    }
    
    func finishLoggingIn() {
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        guard let mainNavigationController = rootViewController as? MainNavigationController else { return }
        mainNavigationController.viewControllers = [HomeController()]
        
        UserDefaults.standard.setIsLoggedIn(value: true)
        
        
        dismiss(animated: true, completion: nil)
    }
    
    func keyboardHide() {
        
        UIView.animate(withDuration: 0.5, delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        },
                       completion: nil)
        
        
    }
    
    
    func keyboardShow() {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
            let y: CGFloat = UIDevice.current.orientation.isLandscape ? -100 : -60
            self.view.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: self.view.frame.height)
        },
                       completion: nil)
        
    }
    
    private func registerSetup() {
        collectView.register(PageCell.self,
                             forCellWithReuseIdentifier: cellid)
        
        collectView.register(LoginCell.self,
                             forCellWithReuseIdentifier: loginid)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let endXPosition = targetContentOffset.pointee.x
        let pageNumber = Int(endXPosition / view.frame.width)
        pageController.currentPage = pageNumber
        
        if pageNumber == pages.count {
            moveController()
            
        } else {
            pageControllerBottomAnchor?.constant = 0
            nextButtonBottomAnchor?.constant = 16
            skipButtonBottomAnchor?.constant = 16
        }
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
            self.view.layoutIfNeeded()
                        
        }, completion: nil)
    }
    private func moveController() {
        pageControllerBottomAnchor?.constant = 40
        nextButtonBottomAnchor?.constant = -40
        skipButtonBottomAnchor?.constant = -40
        
    }
}




extension LoginController: UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == pages.count {
            let loginCell = collectionView.dequeueReusableCell(withReuseIdentifier: loginid, for: indexPath) as! LoginCell
            loginCell.delegate = self
            return loginCell
        }
        
        let cell = collectView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! PageCell
        
        
        
        let page = pages[indexPath.item]
        cell.page = page
        return cell
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
        
    }
}





