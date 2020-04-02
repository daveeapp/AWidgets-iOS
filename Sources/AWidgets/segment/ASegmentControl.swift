//
//  ASegmentControl.swift
//  
//
//  Created by Davee on 2020/3/30.
//

import UIKit


open class ASegement: UIButton {
    
    // MARK: - Convenience
    
    open var normalTitle: String? {
        get {
            return self.title(for: .normal)
        } set {
            self.setTitle(newValue, for: .normal)
        }
    }
    
    open var selectedTitle: String? {
        get {
            return self.title(for: .selected)
        } set {
            self.setTitle(newValue, for: .selected)
        }
    }
    
    open var normalTitleColor: UIColor? {
        get {
            return self.titleColor(for: .normal)
        } set {
            self.setTitleColor(newValue, for: .normal)
        }
    }
    
    open var selectedTitleColor: UIColor? {
        get {
            return self.titleColor(for: .selected)
        } set {
            self.setTitleColor(newValue, for: .selected)
        }
    }
    
    open var normalImage: UIImage? {
        get {
            return self.image(for: .normal)
        } set {
            self.setImage(newValue, for: .normal)
        }
    }
    
    open var selectedImage: UIImage? {
        get {
            return self.image(for: .selected)
        } set {
            self.setImage(newValue, for: .selected)
        }
    }
    
}

/// 自定义SegmentControl
open class ASegmentControl: UIControl {
    
    /// 两个相邻Segment的间距
    open var itemSpace: CGFloat = 16
    
    /// Segment未选中时的颜色
    open var segmentTintColor: UIColor = .darkGray
    
    /// Segment选中时的颜色
    open var selectedSegmentTintColor: UIColor = .systemBlue
    
    /// 当前选中的Segment 下标
    open var currentIndex: Int = 0
    
    private var _indicatorWidth: CGFloat = 0
    /// 下划线的宽度. 设置为0，则与Segment的宽度相同
    open var indicatorWidth: CGFloat {
        get {
            if _indicatorWidth == 0 {
                return self.itemWidth
            } else {
                return _indicatorWidth
            }
        } set {
            _indicatorWidth = newValue
        }
    }
    
    
    /// 下划线的高度
    open var indicatorHeight: CGFloat = 4
    
    /// 下划线颜色
    open var indicatorColor: UIColor = .systemRed
    
    /// 绑定UIScrollView。 weak reference
    open weak var bondScrollView: UIScrollView? {
        didSet {
            if bondScrollView != nil {
                bondScrollView?.delegate = self
            }
        }
    }
    
    var lastOffset: CGPoint = .zero
    
    /// 标签选项。文字或者图片
    public lazy var items: [Any] = {
        return [Any]()
    }()
    
    private lazy var segments: [ASegement] = {
       return [ASegement]()
    }()
    
    /// H-StackView，用来布局Segments
    lazy var tabStripView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = self.itemSpace
        self.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.itemSpace).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self.itemSpace).isActive = true
        stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        return stackView
    }()
    
    /// 下划线
    lazy var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        view.layer.cornerRadius = self.indicatorHeight / 2
        self.addSubview(view)
        return view
    }()
    
    
    public convenience init(items: [Any]) {
        self.init(frame:.zero)
        // 加载所有的Segment
        for i in 0..<items.count {
            let item = items[i]
            if let text = item as? String {
                self.insertSegment(withTitle: text, at: self.items.count)
            } else if let image = item as? UIImage {
                self.insertSegment(withImage: image, at: self.items.count)
            }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public required init?(coder: NSCoder) {
        super.init(frame: .zero)
    }
    
    /// 插入一个文字Segment
    /// - Parameters:
    ///   - withTitle: 文字
    ///   - index: 待插入的位置。范围[0, items.count]，如果超出上界，则默认为追加至末尾
    public func insertSegment(withTitle: String, at index: Int) {
        var realIndex = index
        if index > self.items.count {
            realIndex = self.items.count
        }
        
        self.items.insert(withTitle, at: realIndex)
        let segment = self.makeSegment(withTitle)
        self.tabStripView.insertArrangedSubview(segment, at: realIndex)
        self.segments.insert(segment, at: realIndex)
        self.recheckSelection()
    }
    
    /// 插入一个图片Segment
    /// - Parameters:
    ///   - image: 图片
    ///   - index: 待插入的位置。范围[0, items.count]，如果超出上界，则默认为追加至末尾
    public func insertSegment(withImage image: UIImage, at index: Int) {
        var realIndex = index
        if index > self.items.count {
            realIndex = self.items.count
        }
        
        self.items.insert(image, at: realIndex)
        let segment = self.makeSegment(image)
        self.tabStripView.insertArrangedSubview(segment, at: realIndex)
        self.segments.insert(segment, at: realIndex)
        self.recheckSelection()
    }
    
    /// 设置选中的Segment
    /// - Parameters:
    ///   - index: 选中的位置
    ///   - notify: 是否触发 UIControl.Event.valueChanged. 默认为false
    public func setSelectedSegment(at index: Int, notify: Bool = false) {
        if index != self.currentIndex {
            self.onSelectionChanged(newIndex: index, notify: notify)
        }
    }
    
    /// 创建一个Segment
    /// - Parameter item: String或Image
    fileprivate func makeSegment(_ item: Any) -> ASegement {
        let segmentItem = ASegement()
        segmentItem.normalTitleColor = self.segmentTintColor
        segmentItem.selectedTitleColor = self.selectedSegmentTintColor
        segmentItem.addTarget(self, action: #selector(onItemClicked(item:)), for: .touchUpInside)
        
        if let text = item as? String {
            segmentItem.normalTitle = text
        } else if let image = item as? UIImage {
            segmentItem.normalImage = image
        } else {
            // only for String or UIImage
        }
        return segmentItem
    }
    
    fileprivate func centerXForItem(index: Int) -> CGFloat {
        let count = self.items.count
        let frame = self.tabStripView.frame
        let itemWidth = (frame.size.width - self.itemSpace * CGFloat(count - 1)) / CGFloat(count)
        let centerX = frame.origin.x + itemWidth / 2 + (itemWidth + self.itemSpace) * CGFloat(index)
        return centerX
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        var indicatorFrame = CGRect(x: 0, y: 0, width: self.itemWidth, height: self.indicatorHeight)
        indicatorFrame.origin.y = self.bounds.height - self.indicatorHeight
        indicatorFrame.origin.x = centerXForItem(index: self.currentIndex) - indicatorFrame.width / 2
        self.indicatorView.frame = indicatorFrame
    }
    
    // MARK: - Selection Event
    
    private func indexOfSegment(_ segment: ASegement) -> Int {
        return self.segments.firstIndex(of: segment) ?? 0
    }
    
    private func segmentOfIndex(_ index: Int) -> ASegement? {
        if index >= 0 && index < self.items.count {
            return self.tabStripView.arrangedSubviews[index] as? ASegement
        } else {
            return nil
        }
    }
    
    /// 重新检测选中状态
    private func recheckSelection() {
        for i in 0..<self.segments.count {
            self.segments[i].isSelected = (i == self.currentIndex)
        }
    }
    
    @objc
    func onItemClicked(item: ASegement) {
        if self.isBindToScrollView {
            // 如果当前绑定的scrollView正在拖动，则不处理Segment的点击事件
            if self.isScrollTracking {
                return
            }
            let index = self.indexOfSegment(item)
            if currentIndex != index {
                self.onSelectionChanged(newIndex: index, notify: true, animate: false)
                // 滚动ScrollView到指定页面
                self.scrollToPage(page: index)
            }
        } else {
            // 未绑定ScrollView
            let index = self.indexOfSegment(item)
            if currentIndex != index {
                self.onSelectionChanged(newIndex: index, notify: true)
            }
        }
    }
    
    /// 当选中位置发生变化
    /// - Parameters:
    ///   - newIndex: 新的位置
    ///   - notify: 是否通知
    ///   - animate: 是否移动Indicator。默认为true
    func onSelectionChanged(newIndex: Int, notify: Bool, animate: Bool = true) {
        // deselect old
        self.segments[currentIndex].isSelected = false
        // select new
        self.segments[newIndex].isSelected = true
        
        if animate {
            // Animate indicator view
            self.transIndicator(fromIndex: currentIndex, toIndex: newIndex)
        }
        
        self.currentIndex = newIndex
        
        if notify {
            // notify the selected index changed
            self.sendActions(for: .valueChanged)
        }
    }
    
    /// 移动IndicatorView
    /// - Parameters:
    ///   - fromIndex: 当前位置
    ///   - toIndex: 目标位置
    func transIndicator(fromIndex: Int, toIndex: Int) {
        let offset = CGFloat(toIndex - fromIndex) * (self.itemWidth + self.itemSpace)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.indicatorView.center.x += offset
            self.indicatorView.transform = CGAffineTransform.init(scaleX: 0.5, y: 1.0)
        }) { (finish) in
            UIView.animate(withDuration: 0.25) {
                self.indicatorView.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
            }
        }
    }
    
    // MARK: - Scroll Observing
    
//    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        guard let hasKeyPath = keyPath, let hasChange = change else {
//            return
//        }
//        guard let hasBondScrollView = self.bondScrollView else {
//            return
//        }
//
//        if hasKeyPath.elementsEqual(ContentOffsetPath) {
//            let old = hasChange[.oldKey] as! CGPoint
//            let new = hasChange[.newKey] as! CGPoint
//            let dx = new.x - old.x
//
//            let factor = (self.itemWidth + self.itemSpace) / hasBondScrollView.bounds.width
////            self.indicatorView.transform.tx = new.x * factor
//            self.indicatorView.center.x += dx * factor
//            self.checkSelectedIndex()
//        }
//    }
    
    /// 根据indicator的cx位置，计算出当前选中的segment
    private func checkSelectedIndex() {
        // rcx: 下划线中心点相对于TabStripView的位置
        let rcx = self.indicatorView.frame.origin.x - self.tabStripView.frame.origin.x + self.indicatorWidth / 2
        let index = Int((rcx) / (self.itemWidth + self.itemSpace))
        if index != self.currentIndex {
            self.onSelectionChanged(newIndex: index, notify: true, animate: false)
        }
    }
}

// MARK: - Convenience
public extension ASegmentControl {
    
    var itemWidth: CGFloat {
        get {
            if items.count == 0 {
                return 0
            }
            return (tabStripView.frame.size.width - self.itemSpace * CGFloat(items.count - 1)) / CGFloat(items.count)
        }
    }
    
}

// MARK: - Bind to ScrollView

extension ASegmentControl: UIScrollViewDelegate {
    
    var isBindToScrollView: Bool {
        return bondScrollView != nil
    }
    
    var isScrollTracking: Bool {
        return bondScrollView == nil ? false : bondScrollView!.isTracking
    }
    
    func scrollFactor(pageWidth: CGFloat) -> CGFloat{
        if pageWidth == 0 {
            return 0
        }
        return (self.itemWidth + self.itemSpace) / pageWidth
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x - self.lastOffset.x
        self.scrollIndicator(offset: offsetX, pageWidth: scrollView.bounds.width)
        self.lastOffset = scrollView.contentOffset
    }
    
    func scrollIndicator(offset: CGFloat, pageWidth: CGFloat) {
        if !isBindToScrollView {
            return;
        }
        let factor = self.scrollFactor(pageWidth: pageWidth)
        let dx = offset * factor
        self.indicatorView.center.x += dx
        self.checkSelectedIndex()
    }
    
    func scrollToPage(page: Int) {
        var contentOffset = self.bondScrollView!.contentOffset
        contentOffset.x = self.bondScrollView!.bounds.width * CGFloat(page)
        self.bondScrollView!.setContentOffset(contentOffset, animated: true)
    }
    
}
