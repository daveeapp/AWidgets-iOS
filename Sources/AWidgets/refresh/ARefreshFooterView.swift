//
//  ARefreshFooterView.swift
//  AWidgets
//
//  Created by Davee on 2020/4/5.
//

import UIKit

public protocol ARefreshFooterDelegate: class {
    
    func onLoading(_ footer: ARefreshFooterView)
    
}

open class ARefreshFooterView: ARefreshView {
    
    /// 当UiScrollView滑动到底部时，自动加载
    open var autoLoadMore: Bool = false
    
    /// 当距离ScrollView底部多少距离时触发自动加载
    open var autoLoadOffset: CGFloat = 0
    
    open var isHiddenWhenNomoreData: Bool = false {
        didSet {
            if self.refreshState == .nomore {
                self.onNomoreState()
            }
        }
    }
    
    /// 是否还有更多数据
    open var hasNomoreData: Bool = false {
        didSet {
            if hasNomoreData {
                self.refreshState = .initial
            } else {
                self.refreshState = .nomore
            }
        }
    }
    
    public weak var delegate: ARefreshFooterDelegate?
    
    /// 如果当前ScrollView的内容未超过一屏幕，则按照它的frame高度来判断，否则按照它的ContentSize高度来判断
    var scrollViewMaxY: CGFloat {
        guard let hasScrollView = self.scrollView else {
            return 0
        }
        return max(hasScrollView.contentSize.height,
                   hasScrollView.bounds.height)
    }
    
    func updateFrame() {
        self.frame.origin.x = 0
        self.frame.origin.y = self.scrollViewMaxY
    }
    
    open func startLoading() {
        self.refreshState = .loading
    }
    
    open func stopLoading() {
        self.refreshState = .finished
    }
    
    override func onContentSizeChanged(oldSize: CGSize, newSize: CGSize) {
        self.updateFrame()
    }
    
    override func onContentOffsetChanged(oldOffset: CGPoint, newOffset: CGPoint) {
        if newOffset.y < 0 {
            return // 过滤下拉的情况
        }
        
        let offsetY = newOffset.y + self.scrollView!.height - self.frame.minY
        if offsetY < 0 {
            return
        }
        
        // 自动加载
        if autoLoadMore {
            if offsetY > -self.autoLoadOffset {
                self.refreshState = .loading
            }
            return
        }
        
        let progress = self.height > 0 ? offsetY / self.height : 0
        if progress == 0 {
            self.refreshState = .initial
            
        } else if progress > 0 && progress < 1 {
            if scrollView!.isDragging {
                self.refreshState = .pulling(progress: progress)
            } else {
                self.refreshState = .initial
            }
            
        } else {
            if scrollView!.isDragging {
                self.refreshState = .pulling(progress: 1.0)
            } else {
                self.refreshState = .loading
            }
        }
        
    }
    
    override func onInitialState() {
        self.hideFooterView()
    }
    
    override func onLoadingState() {
        self.showFooterView()
        self.delegate?.onLoading(self)
    }
    
    override func onFinishState() {
        // default option
        self.refreshState = .initial
    }
    
    override func onNomoreState() {
        self.isHidden = self.isHiddenWhenNomoreData
    }

    
    func showFooterView() {
        UIView.animate(withDuration: 0.25) {
            self.scrollView?.contentInset.bottom = self.height
        }
    }
    
    func hideFooterView() {
        UIView.animate(withDuration: 0.25, animations: {
            self.scrollView?.contentInset = self.originContentInset
        })
    }
}
