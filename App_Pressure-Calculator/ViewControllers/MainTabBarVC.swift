//
//  MainTabBarVC.swift
//  App_Pressure-Calculator
//
//  Created by Anastasia Kantor on 2020-11-09.
//

import UIKit

class MainTabBarVC: UITabBarController, UITabBarDelegate {

    let ruby = RubyVC()
    let diamond = DiamondVC()

    let tabs = UITabBarController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MainTabBarVC.UITabBarDelegate = ?=?????

        // Do any additional setup after loading the view.
    }
    
}
