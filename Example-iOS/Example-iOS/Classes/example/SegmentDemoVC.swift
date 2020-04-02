//
//  SegmentDemoVC.swift
//  Example-iOS
//
//  Created by Davee on 2020/3/31.
//  Copyright © 2020 Davee. All rights reserved.
//

import UIKit
import AWidgets

class SegmentDemoVC: UIViewController, UIScrollViewDelegate {
    
    var segment2: ASegmentControl!
    
    var scrollView: UIScrollView!
    var lastOffset: CGPoint = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.segment2 = ASegmentControl(items: ["Tab1", "Tab2", "Tab3"])
        self.segment2.backgroundColor = .lightGray
        self.view.addSubview(self.segment2)
        self.segment2.addTarget(self, action: #selector(onSegmentChanged(segmentControl:)), for: .valueChanged)
        
        self.segment2.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        
        self.scrollView = UIScrollView()
        self.scrollView.isPagingEnabled = true;
        self.scrollView.delegate = self;
        self.view.addSubview(self.scrollView)
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        self.scrollView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.segment2.snp.bottom)
        }
        self.scrollView.contentSize = CGSize(width: screenWidth * 3, height: 0)
        
        let view1 = UIView()
        view1.backgroundColor = .systemGreen
        view1.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        self.scrollView.addSubview(view1)
        
        let view2 = UIView()
        view2.backgroundColor = .systemBlue
        view2.frame = CGRect(x: screenWidth, y: 0, width: screenWidth, height: screenHeight)
        self.scrollView.addSubview(view2)
        
        let view3 = UIView()
        view3.backgroundColor = .systemTeal
        view3.frame = CGRect(x: screenWidth*2, y: 0, width: screenWidth, height: screenHeight)
        self.scrollView.addSubview(view3)
        
        self.segment2.bondScrollView = scrollView
    }
    
    @objc
    func onSegmentChanged(segmentControl: ASegmentControl) {
        print("selected segment: \(segmentControl.currentIndex)")
    }
    

}
