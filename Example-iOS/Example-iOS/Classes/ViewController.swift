//
//  ViewController.swift
//  Example-iOS
//
//  Created by Davee on 2020/3/31.
//  Copyright © 2020 Davee. All rights reserved.
//

import UIKit
import AWidgets

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView!
    
    var sections: [[String]] = [["ASegmentControl", "ACarouselView", "ARefreshView"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tableView = UITableView(frame: .zero, style: .grouped)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        
    }
    
    func title(at indexPath: IndexPath) -> String {
        return self.sections[indexPath.section][indexPath.row]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = self.title(at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = self.title(at: indexPath)

        if title.elementsEqual("ASegmentControl") {
            self.navigationController?.pushViewController(SegmentDemoVC(), animated: true)

        } else if title.elementsEqual("ACarouselView") {
            self.navigationController?.pushViewController(CarouselEmoVC(), animated: true)
        } else if title.elementsEqual("ARefreshView") {
            self.navigationController?.pushViewController(RefreshDemoVC(), animated: true)
        }
        
    }
}

