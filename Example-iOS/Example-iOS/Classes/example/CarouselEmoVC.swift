//
//  CarouselEmoVC.swift
//  Example-iOS
//
//  Created by Davee on 2020/4/2.
//  Copyright © 2020 Davee. All rights reserved.
//

import UIKit
import AWidgets

class CarouselEmoVC: UIViewController {
    
    var carouselView: ACarouselView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        carouselView = ACarouselView(loopEnable: true)
        self.view.addSubview(carouselView)
        
        carouselView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(270)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        
//        setModels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setModels()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        setModels()
//        carouselView.reloadDataIfNeeds()
    }
    
    
    func setModels() {
        var models = [ACarouselModel]()
        for _ in 0..<4 {
            models.append(ACarouselModel(title: nil, image: #imageLiteral(resourceName: "img_carousel_placeholder")))
        }
        self.carouselView.cellModels = models
    }

}
