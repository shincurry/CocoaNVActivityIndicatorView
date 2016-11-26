//
//  ViewController.swift
//  CocoaNVActivityIndicatorViewDemo
//
//  Created by ShinCurry on 2016/11/26.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import Cocoa
import CocoaNVActivityIndicatorView

class ViewController: NSViewController, NVActivityIndicatorViewable {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor(red: CGFloat(237 / 255.0), green: CGFloat(85 / 255.0), blue: CGFloat(101 / 255.0), alpha: 1).cgColor
        let cols = 8
        let rows = 4
        let cellWidth = Int(self.view.frame.width / CGFloat(cols))
        let cellHeight = Int(self.view.frame.height / CGFloat(rows))
        
        (NVActivityIndicatorType.ballPulse.rawValue ... NVActivityIndicatorType.audioEqualizer.rawValue).forEach {
            let x = ($0 - 1) % cols * cellWidth
            let y = ($0 - 1) / cols * cellHeight
            let frame = CGRect(x: x, y: y, width: cellWidth, height: cellHeight)
            let activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                                type: NVActivityIndicatorType(rawValue: $0)!)
            let animationTypeLabel = NSTextField(frame: frame)
            animationTypeLabel.isBezeled = false
            animationTypeLabel.drawsBackground = false
            animationTypeLabel.isEditable = false
            animationTypeLabel.isSelectable = false
            
            animationTypeLabel.stringValue = String($0)
            animationTypeLabel.sizeToFit()
            animationTypeLabel.textColor = NSColor.white
            animationTypeLabel.frame.origin.x += 5
            animationTypeLabel.frame.origin.y += CGFloat(cellHeight) - animationTypeLabel.frame.size.height
            
            activityIndicatorView.padding = 20
            if ($0 == NVActivityIndicatorType.orbit.rawValue) {
                activityIndicatorView.padding = 0
            }
            self.view.addSubview(activityIndicatorView)
            self.view.addSubview(animationTypeLabel)

            activityIndicatorView.startAnimating()
            
            let button = NSButton(frame: frame)
            button.title = ""
            button.tag = $0
            button.bezelStyle = NSBezelStyle.regularSquare
            button.isBordered = false
            button.target = self
            button.action = #selector(buttonTapped(_:))
            self.view.addSubview(button)

        }
        
    }

    func buttonTapped(_ sender: NSButton) {
        let size = CGSize(width: 40, height: 40)
        
        startAnimating(view, size: size, message: "Loading...", type: NVActivityIndicatorType(rawValue: sender.tag)!)
        perform(#selector(delayedStopActivity),
                with: nil,
                afterDelay: 2.5)
    }
    func delayedStopActivity() {
        stopAnimating()
    }

}

