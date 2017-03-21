//
//  ViewController.swift
//  LottieAnimation
//
//  Created by Eashir Arafat on 2/16/17.
//  Copyright © 2017 Evan. All rights reserved.
//

import UIKit
import Lottie
import SnapKit

class WalkthroughViewController: UIViewController, UIScrollViewDelegate {
  var walkthroughStringArray = ["This is your Kagami Mirror ","These are your widgets", "Drag the widget into the mirror!", "Tap the widget for its settings"]
  
  override var prefersStatusBarHidden: Bool {
    return false
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let _ = UIApplication.shared.setStatusBarHidden(false, with: .slide)
    view.backgroundColor = .black
    
    setupViewHierarchy()
    configureConstraints()
    
    scrollView.delegate = self
    setupScrollView()
    setupPageController()
  }
  
  //MARK: ScrollView
  
  func setupScrollView() {
    scrollView.contentSize = CGSize(width: self.view.frame.size.width * 4, height: view.frame.size.height)
    
    for i in 0...3  {
      let label = UILabel(frame: CGRect(x: scrollView.center.x + CGFloat(i) * self.view.frame.size.width, y: ((self.view.frame.size.height) * (0.77)), width: self.view.frame.size.width  , height: 30))
      label.font = UIFont(name: "Code-Pro-Demo", size: 20)
      label.textAlignment = .center
      label.text = walkthroughStringArray[i]
      label.backgroundColor = .black
      label.textColor = .white
      scrollView.addSubview(label)
      
      let _ = [
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ].map{ $0.isActive = true }
    }
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let progress = scrollView.contentOffset.x / scrollView.contentSize.width
    kagamiAnimationView.animationProgress = progress
  }
  
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    let currentPage = Int(targetContentOffset.pointee.x / view.frame.width)
    pageController.currentPage = currentPage
    if currentPage == walkthroughStringArray.count - 1 {
      diveInButton.alpha = 0
      diveInButton.isHidden = false
      UIView.animate(withDuration: 1.0) {
        self.diveInButton.alpha = 1
      }
    }
  }
  
  // MARK: PageController
  func setupPageController() {
    scrollView.addSubview(pageController)
    let _ = [
      pageController.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
      pageController.leftAnchor.constraint(equalTo: view.leftAnchor),
      pageController.rightAnchor.constraint(equalTo: view.rightAnchor),
      ].map{$0.isActive = true
    }
  }
  
  // MARK: Setup
  func setupViewHierarchy () {
    view.addSubview(kagamiAnimationView)
    view.addSubview(scrollView)
    view.addSubview(diveInButton)
  }
  
  func configureConstraints() {
    diveInButton.snp.makeConstraints { (view) in
      view.bottom.equalToSuperview().offset(-8)
      view.centerX.equalToSuperview()
      view.width.equalTo(80)
    }
    
    kagamiAnimationView.snp.makeConstraints { (view) in
      view.leading.trailing.equalToSuperview()
      view.top.equalToSuperview().inset(50)
      view.height.equalToSuperview().multipliedBy(0.7)
    }
    
    scrollView.snp.makeConstraints { (view) in
      view.bottom.leading.trailing.top.equalToSuperview()
    }
  }
  
  // MARK: Actions
  func diveIn() {
    let kagamiVC = KagamiViewController()
    self.present(kagamiVC, animated: true, completion: nil)
    
    let userDefaults = UserDefaults.standard
    userDefaults.setValue(true, forKey: "didViewTour")
  }
  
  // MARK: Lazy vars
  lazy var pageController: UIPageControl = {
    let pageControl = UIPageControl()
    pageControl.translatesAutoresizingMaskIntoConstraints = false
    pageControl.pageIndicatorTintColor = .lightGray
    pageControl.currentPageIndicatorTintColor = .white
    pageControl.numberOfPages = 4
    return pageControl
  }()
  
  //Views
  lazy var kagamiAnimationView: LOTAnimationView = {
    var view: LOTAnimationView = LOTAnimationView(name: "KagamiWalkthrough")
    view.contentMode = .scaleAspectFill
    return view
  }()
  
  lazy var mirrorImageView: UIImageView = {
    let image = #imageLiteral(resourceName: "kagamiMirror.png")
    let imageView = UIImageView(image: image)
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  lazy var scrollView: UIScrollView = {
    var view: UIScrollView = UIScrollView()
    view.isPagingEnabled = true
    view.backgroundColor = .clear
    view.alpha = 0.9
    return view
  }()
  
  //Buttons
  lazy var diveInButton: UIButton = {
    let button = UIButton(type: .roundedRect)
    button.setTitle("Dive in", for: .normal)
    button.titleLabel?.font = UIFont(name: "Code-Pro-Demo", size: 14)
    button.isHidden = true
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitleColor(UIColor.white, for: .normal)
    button.backgroundColor = UIColor.lightGray
    button.layer.cornerRadius = 10
    button.addTarget(self, action: #selector(diveIn), for: .touchUpInside)
    
    return button
  }()
}
