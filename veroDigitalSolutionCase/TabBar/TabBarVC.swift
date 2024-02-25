//
//  TabBarViewController.swift
//  veroDigitalSolutionCase
//
//  Created by Furkan Deniz Albaylar on 20.02.2024.
//

import UIKit

class TabBarVC: UIViewController {
    let tabbar = UITabBarController()
    let firstVC = ListVC()
    let secondVC = QrVC()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        
    }
    func setupUI(){
        
        tabbar.tabBar.layer.cornerRadius = 15
        tabbar.tabBar.layer.opacity = 2
        tabbar.tabBar.tintColor = .white
        firstVC.view.backgroundColor = .darkGray
        firstVC.tabBarItem = UITabBarItem(title: "Task List", image: UIImage(systemName: "checklist.checked")?.withRenderingMode(.alwaysOriginal), tag: 0)
        secondVC.view.backgroundColor = .darkGray
        secondVC.tabBarItem = UITabBarItem(title: "QR", image: UIImage(systemName: "qrcode")?.withRenderingMode(.alwaysOriginal), tag: 1)
        tabbar.tabBar.backgroundColor = .gray
        
        let viewControllers = [firstVC,secondVC]
        tabbar.viewControllers = viewControllers
        self.addChild(tabbar)
        self.view.addSubview(tabbar.view)
        tabbar.view.frame = self.view.frame
    }
}

