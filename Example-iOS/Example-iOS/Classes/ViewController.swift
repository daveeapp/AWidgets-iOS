//
//  ViewController.swift
//  Example-iOS
//
//  Created by Davee on 2020/3/31.
//  Copyright © 2020 Davee. All rights reserved.
//

import UIKit
import AWidgets

class ViewController: UIViewController {
    
    var segment2: ASegment!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.segment2 = ASegment()
        self.view.addSubview(self.segment2)
        
        self.segment2.frame = CGRect(x: 0, y: 100, width: 240, height: 64)
    }


}

