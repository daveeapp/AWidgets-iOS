//
//  ARefreshView.swift
//  AWidgets
//
//  Created by Davee on 2020/4/5.
//

import UIKit

//public protocol ARefreshDelegate: class {
//    func onRefresh()
//    func onLoading()
//}

/// 下拉/上拉状态
public enum ARefreshState: Equatable, CustomStringConvertible {
    case initial
    case pulling(progress: CGFloat)
    case loading
    case finished
    case nomore
    
    static public func ==(a: ARefreshState, b: ARefreshState) -> Bool {
        switch (a, b) {
        case (.initial, .initial):
            return true
        case (.pulling, .pulling):
            return true
        case (.loading, .loading):
            return true
        case (.finished, .finished):
            return true
        case (.nomore, .nomore):
            return true
        default:
            return false
        }
    }
    
    public var description: String {
        switch self {
        case .initial:
            return "initial"
        case .pulling(let p):
            return "pulling:\(p)"
        case .loading:
            return "loading"
        case .finished:
            return "finished"
        case .nomore:
            return "nomore"
        }
    }
}

/// 下拉刷新 + 上拉加载
open class ARefreshView: UIView {
    
    let kKeyPathContentOffset = "contentOffset"
    let kKeyPathContentSize = "contentSize"

    weak var scrollView: UIScrollView? {
        willSet {
            removeObserving()
        }
        didSet {
            addObserving()
            if self.scrollView != nil {
                originContentInset = self.scrollView!.contentInset
            }
        }
    }
    
    var originContentInset: UIEdgeInsets = .zero
    
    /// 当前刷新状态
    open var refreshState: ARefreshState = .initial {
        didSet {
            if oldValue != self.refreshState {
                onRefreshStateChanged()
            }
        }
    }
    
    
    deinit {
        removeObserving()
    }
    
    func onRefreshStateChanged() {
        print("current state: \(refreshState.description)")
        switch refreshState {
        case .initial:
            onInitialState()
            
        case .pulling(let progress):
            onPullingState(progress: progress)
            
        case .loading:
            onLoadingState()
            
        case .finished:
            onFinishState()
            
        case .nomore:
            onNomoreState()
        }
    }
    
    func onInitialState() {
        
    }
    
    func onPullingState(progress: CGFloat) {
        
    }
    
    func onLoadingState() {
        
    }
    
    func onFinishState() {
        
    }
    
    func onNomoreState() {
        
    }
    
    // MARK: - KVO: contentOffset
    
    func addObserving() {
        guard let hasScrollView = scrollView else { return }
        hasScrollView.addObserver(self, forKeyPath: kKeyPathContentOffset, options: [.old, .new], context: nil)
        hasScrollView.addObserver(self, forKeyPath: kKeyPathContentSize, options: [.old, .new], context: nil)
    }
    
    func removeObserving() {
        guard let hasScrollView = scrollView else { return }
        hasScrollView.removeObserver(self, forKeyPath: kKeyPathContentOffset)
        hasScrollView.removeObserver(self, forKeyPath: kKeyPathContentSize)
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let hasKeyPath = keyPath,
            let hasObject = object as? UIScrollView,
            let hasChange = change else {
                super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
                return
        }
        
        if hasKeyPath.elementsEqual(kKeyPathContentOffset) {
            
            switch self.refreshState {
            case .loading, .finished, .nomore:
                return
            default:
                if self.refreshState == .initial && !hasObject.isDragging {
                    return
                }
                
                self.onContentOffsetChanged(oldOffset: hasChange[.oldKey] as! CGPoint,
                                            newOffset: hasChange[.newKey] as! CGPoint)
            }
            
        } else if hasKeyPath.elementsEqual(kKeyPathContentSize) {
            let old = hasChange[.oldKey] as! CGSize
            let new = hasChange[.newKey] as! CGSize
            if old != new {
                self.onContentSizeChanged(oldSize: hasChange[.oldKey] as! CGSize,
                                          newSize: hasChange[.newKey] as! CGSize)
            }
        }
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
        
    }

    func onContentOffsetChanged(oldOffset: CGPoint, newOffset: CGPoint) {
        
    }
    
    func onContentSizeChanged(oldSize: CGSize, newSize: CGSize) {
//        print("oldSize:\(oldSize), newSize:\(newSize)")
    }
}
