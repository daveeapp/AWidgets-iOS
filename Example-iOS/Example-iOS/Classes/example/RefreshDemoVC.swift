//
//  RefreshDemoVC.swift
//  Example-iOS
//
//  Created by Davee on 2020/4/5.
//  Copyright © 2020 Davee. All rights reserved.
//

import UIKit
import AWidgets

class RefreshDemoVC: UIViewController, UITableViewDataSource,
                        ARefreshHeaderDelegate, ARefreshFooterDelegate {
    
    
    var tableView: UITableView!
    
    var count = 15

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
        
        self.tableView = UITableView(frame: .zero, style: .grouped)
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        
        let header = ADefaultRefreshHeader()
        header.delegate = self
        self.tableView.addRefreshHeader(header)
        
        let footer = ADefaultRefreshFooter()
        footer.delegate = self
        footer.isHiddenWhenNomoreData = false
        footer.autoLoadMore = true
        footer.autoLoadOffset = 44
        self.tableView.addRefreshFooter(footer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
//            self.tableView.startHeaderRefreshing()
//        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = "section: \(indexPath.section), row: \(indexPath.row)"
        return cell
    }
    
    func onRefresh(_ header: ARefreshHeaderView) {
        print("onRefresh.......")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.count = 5
            self.tableView.reloadData()
            header.stopRefreshing()
            self.tableView.hasNomoreData = false
//            self.tableView.stopHeaderRefreshing()
        }
    }
    
    func onLoading(_ footer: ARefreshFooterView) {
        print("loading.......")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.count += 5
            self.tableView.reloadData()
            footer.stopLoading()
            if self.count == 25 {
                footer.hasNomoreData = true
            }
        }
    }
}
