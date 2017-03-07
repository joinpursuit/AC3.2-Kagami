//
//  SettingsViewController.swift
//  Kagami
//
//  Created by Eric Chang on 3/6/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    // MARK: - Properties
    // Type of setting will go here
    // Will be passed from KagamiViewController
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Based on selected setting, use appropriate view
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /**
     *
     * All View Logic will be in this View Controller FOR SETTINGS
     *
     *
     * All View properties will be in respective Views
     * The selected settings view will be shown
     */
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // Lazy Instantiates
    lazy var weatherSettingsView: WeatherView = {
        let view = WeatherView()
        
        return view
    }()

}
