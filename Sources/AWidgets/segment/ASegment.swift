//
//  ASegment.swift
//  
//
//  Created by Davee on 2020/3/30.
//

import UIKit

open class ASegementItem: UIControl {
    
//    private var stackView: UIStackView!
    
//    private var imageView: UIView!
    
//    open var titleLabel: UILabel!
//
//    public override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.loadSubviews()
//    }
//
//    public required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
//
//    open func loadSubviews() {
//        self.titleLabel = UILabel()
//        self.titleLabel.textColor = .black
//        self.titleLabel.textAlignment = .center
//
//        self.addSubview(self.titleLabel)
//    }
//
//    open override func layoutSubviews() {
//        var titleFrame = self.titleLabel.frame
//
//    }
//
//    fileprivate func textSizeOf(text: String, attrs: [NSAttributedString.Key: Any], in bounds: CGRect) {
//        let at = text as NSString
//        at.boundingRect(with: bounds.size, options: .usesLineFragmentOrigin, attributes: attrs, context: nil);
//    }
    
    
}

open class ASegment: UIView {
    
    open var tabStripView: UIStackView!
    
    open var indicatorView: UIView!
    
    open var items = [UIView]()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.loadSubviews()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func loadSubviews() {
        self.tabStripView = UIStackView()
        self.tabStripView.axis = .horizontal
        self.tabStripView.alignment = .center
        self.tabStripView.distribution = .fillEqually
        self.addSubview(self.tabStripView)
        
        self.indicatorView = UIView()
        self.indicatorView.backgroundColor = .systemRed
        self.addSubview(self.indicatorView)
        
        for i in 0..<3 {
            let label = UILabel()
            label.text = "Tab\(i)"
            items.append(label)
            self.tabStripView.addArrangedSubview(label)
        }
    }
    
    open override func layoutSubviews() {
        self.tabStripView.frame = self.bounds
        
        var indicatorFrame = CGRect.zero
        indicatorFrame.size.width = 24
        indicatorFrame.size.height = 4
        indicatorFrame.origin.y = self.bounds.height - 4
        indicatorFrame.origin.x = 0
        self.indicatorView.frame = indicatorFrame
    }
}
