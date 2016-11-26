//
//  NVActivityIndicatorPresenter.swift
//  NVActivityIndicatorViewDemo
//
//  Created by Diego Ernst on 8/31/16.
//  Copyright © 2016 Nguyen Vinh. All rights reserved.
//

import Cocoa

/// Class packages information used to display UI blocker.
public class ActivityData {
    /// Size of activity indicator view.
    let size: CGSize
    
    /// Message displayed under activity indicator view.
    let message: String?
    
    /// Animation type.
    let type: NVActivityIndicatorType
    
    /// Color of activity indicator view.
    let color: NSColor
    
    /// Padding of activity indicator view.
    let padding: CGFloat
    
    /// Display time threshold to actually display UI blocker.
    let displayTimeThreshold: Int
    
    /// Minimum display time of UI blocker.
    let minimumDisplayTime: Int
    
    /**
     Create information package used to display UI blocker.
     
     Appropriate NVActivityIndicatorView.DEFAULT_* values are used for omitted params.
     
     - parameter size:                 size of activity indicator view.
     - parameter message:              message displayed under activity indicator view.
     - parameter type:                 animation type.
     - parameter color:                color of activity indicator view.
     - parameter padding:              padding of activity indicator view.
     - parameter displayTimeThreshold: display time threshold to actually display UI blocker.
     - parameter minimumDisplayTime:   minimum display time of UI blocker.
     
     - returns: The information package used to display UI blocker.
     */
    public init(size: CGSize? = nil,
                message: String? = nil,
                type: NVActivityIndicatorType? = nil,
                color: NSColor? = nil,
                padding: CGFloat? = nil,
                displayTimeThreshold: Int? = nil,
                minimumDisplayTime: Int? = nil) {
        self.size = size ?? NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE
        self.message = message
        self.type = type ?? NVActivityIndicatorView.DEFAULT_TYPE
        self.color = color ?? NVActivityIndicatorView.DEFAULT_COLOR
        self.padding = padding ?? NVActivityIndicatorView.DEFAULT_PADDING
        self.displayTimeThreshold = displayTimeThreshold ?? NVActivityIndicatorView.DEFAULT_BLOCKER_DISPLAY_TIME_THRESHOLD
        self.minimumDisplayTime = minimumDisplayTime ?? NVActivityIndicatorView.DEFAULT_BLOCKER_MINIMUM_DISPLAY_TIME
    }
}

/// Presenter that displays NVActivityIndicatorView as UI blocker.
public class NVActivityIndicatorPresenter {
    private var showTimer: Timer?
    private var hideTimer: Timer?
    private var isStopAnimatingCalled = false
    private let restorationIdentifier = "NVActivityIndicatorViewContainer"
    
    var parentView: NSView?
    
    /// Shared instance of `NVActivityIndicatorPresenter`.
    public static let sharedInstance = NVActivityIndicatorPresenter()
    
    private init() { }
    
    // MARK: - Public interface
    
    /**
     Display UI blocker.
     
     - parameter data: Information package used to display UI blocker.
     */
    public func startAnimating(_ data: ActivityData) {
        guard showTimer == nil else { return }
        isStopAnimatingCalled = false
        showTimer = scheduledTimer(data.displayTimeThreshold, selector: #selector(NVActivityIndicatorPresenter.showTimerFired(_:)), data: data)
    }
    
    /**
     Remove UI blocker.
     */
    public func stopAnimating() {
        isStopAnimatingCalled = true
        guard hideTimer == nil else { return }
        hide()
    }
    
    // MARK: - Timer events
    
    @objc private func showTimerFired(_ timer: Timer) {
        guard let activityData = timer.userInfo as? ActivityData else { return }
        show(with: activityData)
    }
    
    @objc private func hideTimerFired(_ timer: Timer) {
        hideTimer?.invalidate()
        hideTimer = nil
        if isStopAnimatingCalled {
            hide()
        }
    }
    
    // MARK: - Helpers
    
    private func show(with activityData: ActivityData) {
        guard let view = parentView else {
            return
        }
        let activityContainer: NSView = NSView(frame: view.bounds)
        activityContainer.wantsLayer = true
        activityContainer.layer?.backgroundColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
//        activityContainer.backgroundColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0.5)
//        activityContainer.restorationIdentifier = restorationIdentifier
        let actualSize = activityData.size
        
        var position = CGPoint()
        position.x = (view.bounds.size.width - actualSize.width) / 2
        position.y = (view.bounds.size.height - actualSize.height) / 2
        
        
        let activityIndicatorView = NVActivityIndicatorView(
            frame: CGRect(x: position.x, y: position.y, width: actualSize.width, height: actualSize.height),
            type: activityData.type,
            color: activityData.color,
            padding: activityData.padding)
        

        activityIndicatorView.startAnimating()
        activityContainer.addSubview(activityIndicatorView)
        
        let width = activityContainer.frame.size.width / 3
        
        position.x = (view.bounds.size.width - width) / 2
        position.y = position.y - 40
        if let message = activityData.message , !message.isEmpty {
            let label = NSTextField(frame: CGRect(x: position.x, y: position.y, width: width, height: 30))
            label.isBezeled = false
            label.drawsBackground = false
            label.isEditable = false
            label.isSelectable = false
            
//            label.center = CGPoint(
//                x: activityIndicatorView.center.x,
//                y: activityIndicatorView.center.y + actualSize.height)
            label.alignment = .center
            label.stringValue = message
            label.font = NSFont.boldSystemFont(ofSize: 20)
            label.textColor = activityIndicatorView.color
            activityContainer.addSubview(label)
        }
        
        hideTimer = scheduledTimer(activityData.minimumDisplayTime, selector: #selector(NVActivityIndicatorPresenter.hideTimerFired(_:)), data: nil)
        parentView?.addSubview(activityContainer)
    }
    
    private func hide() {
        if let view = parentView?.subviews.last?.subviews.first as? NVActivityIndicatorView {
            parentView?.subviews.last?.removeFromSuperview()
        }
        
        showTimer?.invalidate()
        showTimer = nil
    }
    
    private func scheduledTimer(_ timeInterval: Int, selector: Selector, data: ActivityData?) -> Timer {
        return Timer.scheduledTimer(timeInterval: Double(timeInterval) / 1000,
                                    target: self,
                                    selector: selector,
                                    userInfo: data,
                                    repeats: false)
    }
}
