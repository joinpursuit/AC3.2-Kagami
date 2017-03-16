//
//  MyKagamiViewController.swift
//  Kagami
//
//  Created by Zachary Drossman on 3/14/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import UIKit

class MyKagamiViewController: KagamiViewController, KagamiViewControllerDataSource {
    
    // MARK: - Properties
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n\n\n --------- \n\n\n \(widgetViews[0]) \n\n\n -------------- \n\n\n\n")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
