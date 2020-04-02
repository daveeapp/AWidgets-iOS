//
//  ACarouselCell.swift
//  AWidgets
//
//  Created by Davee on 2020/4/2.
//

import UIKit

open class ACarouselCell: UICollectionViewCell {
    
    static let IDENTIFIER = "ACarouselCell"
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        self.addSubview(label)
        return label
    }()
    
    public lazy var imageView: UIImageView = {
        let imgV = UIImageView()
        imgV.backgroundColor = .white
        self.addSubview(imgV)
        return imgV
    }()
    
    open var cellModel: ACarouselModel? {
        didSet {
            setupModel()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        super.init(frame: .zero)
    }
    
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageView.frame = self.bounds
    }
    
    open func setupModel() {
        guard let hasModel = cellModel else { return }
        
        if let hastitle = hasModel.title {
            self.titleLabel.text = hastitle
        }
        
        if let hasImage = hasModel.image {
            self.imageView.image = hasImage
        }
    }
}
