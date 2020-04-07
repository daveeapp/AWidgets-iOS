//
//  ACarouselView.swift
//  AWidgets
//
//  Created by Davee on 2020/4/2.
//

import UIKit

@objc public protocol ACarouselViewDelegate {
    
    @objc optional func carouselView(_ carouselView: ACarouselView, cellSizeAt indexPath: IndexPath) -> CGSize
    
    @objc optional func carouselView(_ carouselView: ACarouselView, didSelect page: Int)
    
}

/// 自定义轮播图片的控件
open class ACarouselView: UIView {
    
    var collectionView: UICollectionView!
    
    var collectionLayout: UICollectionViewFlowLayout!
    
    var pageControl: UIPageControl!
    
    /// 是否循环播放。默认为true
    var loopEnable: Bool = true
    
    /// 图片资源。如果当前
    open var cellModels: [ACarouselModel]? {
        didSet {
            _needsReloadData = true
        }
    }
    
    /// Cell的宽度，默认为CollectionView的宽度
    open var cellWidth: CGFloat {
        return self.width
    }
    
    /// Cell的高度.默认270
    open var cellHeight: CGFloat = 270
    
    open weak var delegate: ACarouselViewDelegate?
    
    /// 图片数量
    private var numberOfModels: Int {
        return self.cellModels == nil ? 0 : self.cellModels!.count
    }
    
    /// 自动播放定时器
    private var timer: Timer?
    
    /// 自动播放间隔时间（秒）
    open var timeInterval: TimeInterval = 2.5
    
    /// 记录collectionView当前展示的cell位置。范围 [0, numberOfRows]
    private var nowItemIndex: Int = 0
    
    /// 记录当前选中的页面。范围[0, cellModels.count]
    private var nowPageIndex: Int = 0
    
    /// 标记是否需要重载数据
    private var _needsReloadData: Bool = false
    
    /// =========================
    
    deinit {
        invalidateTimer()
    }
    
    convenience
    public init(loopEnable: Bool) {
        self.init(frame: .zero)
        self.loopEnable = loopEnable
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadSubviews()
    }
    
    required public init?(coder: NSCoder) {
        super.init(frame: .zero)
        self.loadSubviews()
    }
    
    private func loadSubviews() {
        // Setup collectionView
        self.collectionLayout = UICollectionViewFlowLayout()
        self.collectionLayout.scrollDirection = .horizontal
        self.collectionLayout.minimumLineSpacing = 0
        
        self.collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: collectionLayout)
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.isPagingEnabled = true
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(ACarouselCell.self, forCellWithReuseIdentifier: ACarouselCell.IDENTIFIER)
        self.addSubview(collectionView)
        
        // Setup indicatorView
        self.pageControl = UIPageControl()
        self.addSubview(pageControl)
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.pageControl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        self.pageControl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.frame = self.bounds
        self.reloadDataIfNeeds()
    }
    
    public func reloadDataIfNeeds() {
        if _needsReloadData {
            _needsReloadData = false
            self.reloadData()
        }
    }
    
    private func reloadData() {
        collectionView.reloadData()
        
        /// 循环播放
        if self.loopEnable {
            // 初始item位置
            self.nowItemIndex = self.numberOfModels * 500
            // 初始page位置
            self.nowPageIndex = 0
            self.pageControl.numberOfPages = numberOfModels
            self.pageControl.currentPage = nowPageIndex
            self.collectionView.scrollToItem(at: IndexPath(item: nowItemIndex, section: 0), at: .left, animated: false)
            
        } else {
            self.nowItemIndex = 0
            self.nowPageIndex = 0
            self.pageControl.numberOfPages = numberOfModels
            self.pageControl.currentPage = nowPageIndex
            self.collectionView.scrollToItem(at: IndexPath(item: nowItemIndex, section: 0), at: .left, animated: false)
        }
        
        startTimer()
    }
    
    private func pageOf(itemIndex: Int) -> Int {
        return numberOfModels == 0 ? 0 : itemIndex % numberOfModels
    }
    
}

// MARK: - UICollectionViewDataSource
extension ACarouselView: UICollectionViewDataSource {
    
    /// 如果开启循环，则设置一个足够大的item数量
    public var maxItems: Int {
        let count = self.numberOfModels
        return loopEnable ? count * 5000 : count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return maxItems
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ACarouselCell.IDENTIFIER, for: indexPath);
        
        let page = pageOf(itemIndex: indexPath.row)
        (cell as! ACarouselCell).cellModel = self.cellModels![page]
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ACarouselView: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.cellWidth, height: cellHeight)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard self.cellWidth > 0 else { return }
        
        let offsetX = scrollView.contentOffset.x
        self.nowItemIndex = max(0, Int(offsetX / self.cellWidth))
        self.nowPageIndex = pageOf(itemIndex: nowItemIndex)
        self.pageControl.currentPage = nowPageIndex
//        print("nowItemIndex: \(nowItemIndex)")
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let hasDelegate = self.delegate {
            let page = pageOf(itemIndex: indexPath.row)
            hasDelegate.carouselView?(self, didSelect: page)
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        invalidateTimer()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startTimer()
    }
    
}

// MARK: - Timer

extension ACarouselView {
    
    
    func startTimer() {
        invalidateTimer()

        self.timer = Timer(timeInterval: timeInterval, repeats: true, block: { [weak self] (timer) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.scrollToNextPage()
        })
        RunLoop.main.add(self.timer!, forMode: .common)
    }
    
    func invalidateTimer() {
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    func scrollToNextPage() {
        if self.loopEnable {
            var nextItemIndex = self.nowItemIndex + 1
            if nextItemIndex >= self.maxItems {
                nextItemIndex = self.numberOfModels * 500 + self.nowPageIndex
            }
            let offsetX = CGFloat(nextItemIndex) * self.cellWidth
            self.collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
            
        } else {
            var nextItemIndex = self.nowItemIndex + 1
            if nextItemIndex >= self.maxItems {
                nextItemIndex = 0
            }
            
            let offsetX = CGFloat(nextItemIndex) * self.cellWidth
            self.collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        }
    }
    
}
