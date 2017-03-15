//
//  MyKagamiViewController.swift
//  Kagami
//
//  Created by Zachary Drossman on 3/14/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import UIKit

class MyKagamiViewController: KagamiViewController, KagamiViewControllerDataSource {
    internal var widgetViews: [WidgetView]
    
    init(widgetViews: [WidgetView]) {
        self.widgetViews = widgetViews
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
