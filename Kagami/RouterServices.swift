//
//  RouterServices.swift
//  Kagami
//
//  Created by Eric Chang on 3/8/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import Foundation
import UIKit

class Router {
    
    let window : UIWindow
    let navController : UINavigationController?
    var weatherVC : UIViewController?
    
    
    init(window: UIWindow) {
        self.window = window
        let kagamiVC = KagamiViewController()
        
        navController = UINavigationController(rootViewController: kagamiVC)
        
        kagamiVC.didTapWidget = showWeather
        
        window.rootViewController = navController
        window.makeKeyAndVisible()
        
        // nav bar
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 20.0),
                                                            NSForegroundColorAttributeName : UIColor.white]
        
        // status bar
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func showWeather() {
        weatherVC = UIViewController()
        navController?.pushViewController(weatherVC!, animated: true)
//        weatherVC.didTapCancel = hideWeather
    }
    
    func hideWeather() {
        navController?.popViewController(animated: true)
    }
    
}
