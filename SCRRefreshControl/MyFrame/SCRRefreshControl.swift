//
//  SCRefreshControl.swift
//  SCWeiboAssistant
//
//  Created by Stephen Cao on 2/5/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import UIKit

private let navigationBarHeight:CGFloat = 64
public enum SCRefreshStyle{
    case simple
    case anime
}

enum SCRefreshState{
    case normal
    case pulling
    case willRefresh
}
public class SCRRefreshControl: UIControl {
    private var refreshOffset: CGFloat = 0
    private weak var scrollView: UIScrollView?
    private var refreshView : SCRRefreshView?

    private var refreshStyle: SCRefreshStyle = .simple{
        didSet{
            switch refreshStyle {
            case .simple:
                refreshView = SCRRefreshView.refreshView()
            case .anime:
                refreshView = SCRAnimeRefreshView.refreshView()
            }
            refreshOffset = refreshView!.bounds.height
        }
    }
    
    /// - Parameter style: refreshView style
    public init(style: SCRefreshStyle) {
        super.init(frame: CGRect())
        setupUI(style: style)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard let sv = newSuperview as? UIScrollView else {
            return
        }
        scrollView = sv
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
    }
    
    override public func removeFromSuperview() {
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        super.removeFromSuperview()
    }

    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let sv = scrollView else {
            return
        }
        let height = -(sv.contentOffset.y + navigationBarHeight)
        if height < 0{
            return
        }
        refreshView!.isHidden = height == 0
        refreshView!.refreshControlViewHeight = height
        
        frame = CGRect(x: 0, y: -height, width: sv.bounds.width, height: height)
        if sv.isDragging{
            if height > refreshOffset && refreshView!.refreshState == .normal{
                refreshView!.refreshState = .pulling
            }else if height <= refreshOffset && refreshView!.refreshState == .pulling{
                refreshView!.refreshState = .normal
            }
        }else{
            if refreshView!.refreshState == .pulling{
                beginRefreshing()
                sendActions(for: UIControl.Event.valueChanged)
            }
        }
    }
    // May be used to indicate to the refreshControl that an external event has initiated the refresh action
    public func beginRefreshing(){
        guard let sv = scrollView else{
            return
        }
        if refreshView!.refreshState == .willRefresh{
            return
        }
        refreshView!.refreshState = .willRefresh
        sv.contentInset = UIEdgeInsets(top: refreshOffset, left: 0, bottom: 0, right: 0)
        
    }

    // Must be explicitly called when the refreshing has completed
    public func endRefreshing(){
        guard let sv = scrollView else{
            return
        }
        if refreshView!.refreshState != .willRefresh{
            return
        }
        sv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        refreshView!.refreshState = .normal
    }
}

// MARK: - setup refresh UI and constraints
extension SCRRefreshControl{
    private func setupUI(style: SCRefreshStyle){
        refreshStyle = style
        backgroundColor = superview?.backgroundColor
        addSubview(refreshView!)
        setupRefreshView()
    }
    private func setupRefreshView(){
        refreshView!.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(
            item: refreshView!,
            attribute: NSLayoutConstraint.Attribute.centerX,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: self,
            attribute: NSLayoutConstraint.Attribute.centerX,
            multiplier: 1.0, constant: 0))

        addConstraint(NSLayoutConstraint(
            item: refreshView!,
            attribute: NSLayoutConstraint.Attribute.bottom,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: self,
            attribute: NSLayoutConstraint.Attribute.bottom,
            multiplier: 1.0, constant: 0))

        addConstraint(NSLayoutConstraint(
            item: refreshView!,
            attribute: NSLayoutConstraint.Attribute.width,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: nil,
            attribute: NSLayoutConstraint.Attribute.notAnAttribute,
            multiplier: 1.0, constant: refreshView!.bounds.width))

        addConstraint(NSLayoutConstraint(
            item: refreshView!,
            attribute: NSLayoutConstraint.Attribute.height,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: nil,
            attribute: NSLayoutConstraint.Attribute.notAnAttribute,
            multiplier: 1.0, constant: refreshView!.bounds.height))
    }
}

