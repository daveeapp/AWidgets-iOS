//
//  UIScrollView+ARefreshView.swift
//  AWidgets
//
//  Created by Davee on 2020/4/5.
//

import UIKit

private var refreshHeaderKey = 0
private var refreshFooterKey = 1

/// Extension for ARefreshHeaderView
public extension UIScrollView {
    
    fileprivate(set) var refreshHeaderView: ARefreshHeaderView? {
        get {
            return objc_getAssociatedObject(self, &refreshHeaderKey) as? ARefreshHeaderView
        }
        set {
            objc_setAssociatedObject(self, &refreshHeaderKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func addRefreshHeader(_ header: ARefreshHeaderView) {
        removeRefreshHeader()
        
        self.refreshHeaderView = header
        self.refreshHeaderView?.scrollView = self
        self.insertSubview(header, at: 0)
    }
    
    func removeRefreshHeader() {
        refreshHeaderView?.removeFromSuperview()
        refreshHeaderView = nil
    }
    
    func startHeaderRefreshing() {
        self.refreshHeaderView?.startRefreshing()
    }
    
    func stopHeaderRefreshing() {
        self.refreshHeaderView?.stopRefreshing()
    }
    
}

/// Extension for ARefreshFooterView
public extension UIScrollView {
    
    fileprivate(set) var refreshFooterView: ARefreshFooterView? {
        get {
            return objc_getAssociatedObject(self, &refreshFooterKey) as? ARefreshFooterView
        }
        set {
            objc_setAssociatedObject(self, &refreshFooterKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func addRefreshFooter(_ footer: ARefreshFooterView) {
        removeRefreshFooter()
        
        self.refreshFooterView = footer
        self.refreshFooterView?.scrollView = self
        self.insertSubview(footer, at: 0)
    }
    
    func removeRefreshFooter() {
        refreshFooterView?.removeFromSuperview()
        refreshFooterView = nil
    }
    
    func startFooterLoading() {
        self.refreshFooterView?.startLoading()
    }
    
    func stopFooterLoading() {
        self.refreshFooterView?.stopLoading()
    }
    
    var hasNomoreData: Bool {
        get {
            return self.refreshFooterView?.hasNomoreData ?? true
        } set {
            self.refreshFooterView?.hasNomoreData = newValue
        }
    }
}
