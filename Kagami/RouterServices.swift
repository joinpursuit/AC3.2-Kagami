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
    var weatherVC : UIViewController?
    
    
    init(window: UIWindow) {
        self.window = window
        
        window.rootViewController = KagamiViewController()
        window.makeKeyAndVisible()
        
    }
    
    func showWeather() {
        weatherVC = UIViewController()
//        navController?.pushViewController(weatherVC!, animated: true)
//        weatherVC.didTapCancel = hideWeather
    }
    
    func hideWeather() {
//        navController?.popViewController(animated: true)
    }
    
}
