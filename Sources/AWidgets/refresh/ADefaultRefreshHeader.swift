//
//  ADefaultRefreshHeader.swift
//  AWidgets
//
//  Created by Davee on 2020/4/5.
//

import UIKit

/// 一个简单的默认的下拉刷新
open class ADefaultRefreshHeader: ARefreshHeaderView {
    
    public var indicatorView: UIActivityIndicatorView!
    
//    public var titleLabel: UILabel?
    
    public override init(frame: CGRect) {
        let f = CGRect(x: 0, y: 0, width: 414, height: 44)
        super.init(frame: f)
        self.loadSubviews()
    }
    
    public required init?(coder: NSCoder) {
        super.init(frame: .zero)
        self.loadSubviews()
    }
    
    private func loadSubviews() {
        // self.backgroundColor = .systemGreen
        self.indicatorView = UIActivityIndicatorView(style: .whiteLarge)
        self.indicatorView.color = .lightGray
        self.indicatorView.hidesWhenStopped = false
        self.addSubview(indicatorView)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.indicatorView.center = CGPoint(x: self.width / 2, y: self.height / 2)
    }
    
    override func onInitialState() {
        super.onInitialState()
        self.indicatorView.stopAnimating()
    }
    
    override func onLoadingState() {
        super.onLoadingState()
        self.indicatorView.startAnimating()
    }
    
}
