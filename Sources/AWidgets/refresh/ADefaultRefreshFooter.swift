//
//  ADefaultRefreshFooter.swift
//  AWidgets
//
//  Created by Davee on 2020/4/6.
//

import UIKit

/// 一个默认的上拉加载
open class ADefaultRefreshFooter: ARefreshFooterView {

    public var indicatorView: UIActivityIndicatorView!
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.isHidden = true
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        return label
    }()
    
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
        self.backgroundColor = .systemPurple
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
        self.titleLabel.isHidden = true
    }
    
    override func onLoadingState() {
        super.onLoadingState()
        self.indicatorView.startAnimating()
    }
    
    override func onNomoreState() {
        super.onNomoreState()
        self.indicatorView.isHidden = true
        self.titleLabel.isHidden = false
        self.titleLabel.text = "--没有更多--"
    }

}
