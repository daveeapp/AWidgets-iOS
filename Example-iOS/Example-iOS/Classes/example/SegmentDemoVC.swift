//
//  SegmentDemoVC.swift
//  Example-iOS
//
//  Created by Davee on 2020/3/31.
//  Copyright © 2020 Davee. All rights reserved.
//

import UIKit
import AWidgets

class SegmentDemoVC: UIViewController {
    
    
    var segment2: ASegment!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.segment2 = ASegment()
        self.view.addSubview(self.segment2)
        
        self.segment2.addConstraint(self.segment2.leadingAnchor.constraint(equalTo: self.view.leadingAnchor))
        self.segment2.addConstraint(self.segment2.bottomAnchor.constraint(equalTo: self.view.bottomAnchor))
        self.segment2.addConstraint(self.segment2.trailingAnchor.constraint(equalTo: self.view.trailingAnchor))
        self.segment2.addConstraint(self.segment2.heightAnchor.constraint(equalToConstant: 64))
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
