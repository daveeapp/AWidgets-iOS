//
//  ARefreshHeaderView.swift
//  AWidgets
//
//  Created by Davee on 2020/4/5.
//

import UIKit

public protocol ARefreshHeaderDelegate: class {
    func onRefresh(_ header: ARefreshHeaderView)
}

open class ARefreshHeaderView: ARefreshView {
    
    public weak var delegate: ARefreshHeaderDelegate?
    
    open func startRefreshing() {
        self.refreshState = .loading
    }
    
    open func stopRefreshing() {
        self.refreshState = .finished
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if self.superview != nil {
            self.frame.origin.x = 0
            self.frame.origin.y = self.scrollView!.contentInset.top - self.frame.size.height
        }
    }

    override func onContentOffsetChanged(oldOffset: CGPoint, newOffset: CGPoint) {
        if newOffset.y > 0 {
            return // 过滤上拉的情况
        }
        
        let offsetY = -newOffset.y
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
        self.hideHeaderView()
    }
    
    override func onLoadingState() {
        // 通过scrollView.contentInset.top来控制显示header
        self.showHeaderView()
        if let hasDelegate = self.delegate {
            hasDelegate.onRefresh(self)
        }
    }
    
    override func onFinishState() {
        self.refreshState = .initial
    }
    
    /// 显示Header，header显示在顶部
    func showHeaderView() {
        UIView.animate(withDuration: 0.25) {
            var contentInset = self.scrollView!.contentInset
            contentInset.top += self.height
            self.scrollView?.contentInset = contentInset
            self.scrollView?.contentOffset = CGPoint(x: 0, y: -contentInset.top)
        }
    }
    
    /// 隐藏header
    func hideHeaderView() {
        UIView.animate(withDuration: 0.25, animations: {
            self.scrollView?.contentInset = self.originContentInset
        }) { (_) in
            self.refreshState = .initial
//            self.scrollView?.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        }
    }
    
}
