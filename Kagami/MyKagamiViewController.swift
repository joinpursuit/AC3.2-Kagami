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
    internal var widgetViews: [WidgetView]
    
    // MARK: - View Lifecycle
    init(widgetViews: [WidgetView]) {
        self.widgetViews = widgetViews
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n\n\n --------- \n\n\n \(widgetViews[0]) \n\n\n -------------- \n\n\n\n")
        setupViewHierarchy()
        configureConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setup View Hierarchy & Constraints
    func setupViewHierarchy() {
        
        for widgetView in widgetViews {
            self.view.addSubview(widgetView)
            widgetView.backgroundColor = .clear
        }
    }
    
    func configureConstraints() {
        
        for widgetView in widgetViews {
            var count = 0
            widgetView.snp.remakeConstraints({ (make) in
                make.height.equalTo(50.0)
                make.width.equalToSuperview().multipliedBy(0.125)
                make.leading.equalToSuperview().offset((50 * count) + 16)
                make.center.equalToSuperview()
            })
            count += 1
        }
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
