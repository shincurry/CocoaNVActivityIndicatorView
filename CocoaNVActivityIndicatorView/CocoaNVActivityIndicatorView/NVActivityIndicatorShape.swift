//
//  NVActivityIndicatorShape.swift
//  NVActivityIndicatorViewDemo
//
//  Created by Nguyen Vinh on 7/22/15.
//  Copyright (c) 2015 Nguyen Vinh. All rights reserved.
//

import Cocoa

enum NVActivityIndicatorShape {
    case circle
    case circleSemi
    case ring
    case ringTwoHalfVertical
    case ringTwoHalfHorizontal
    case ringThirdFour
    case rectangle
    case triangle
    case line
    case pacman
    
    func layerWith(size: CGSize, color: NSColor) -> CALayer {
        let layer: CAShapeLayer = CAShapeLayer()
        let path: NSBezierPath = NSBezierPath()
        let lineWidth: CGFloat = 2
        
        switch self {
        case .circle:
            path.appendArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius: size.width / 2,
                        startAngle: 0,
                        endAngle: 360.0,
                        clockwise: false);
            layer.fillColor = color.cgColor
        case .circleSemi:
            path.appendArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius: size.width / 2,
                        startAngle: 30.0,
                        endAngle: 150,
                        clockwise: false)
            path.close()
            layer.fillColor = color.cgColor
        case .ring:
            path.appendArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius: size.width / 2,
                        startAngle: 0,
                        endAngle: 360.0,
                        clockwise: false);
            layer.fillColor = nil
            layer.strokeColor = color.cgColor
            layer.lineWidth = lineWidth
        case .ringTwoHalfVertical:
            path.appendArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius: size.width / 2,
                        startAngle: 45,
                        endAngle: 135,
                        clockwise: false)
            path.move(
                to: CGPoint(x: size.width / 2 + (size.width / 2) * CGFloat(cos(5 * Double.pi / 4)),
                            y: size.height / 2 + (size.height / 2) * CGFloat(sin(5 * Double.pi / 4)))
            )

            path.appendArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius: size.width / 2,
                        startAngle: 225,
                        endAngle: 315,
                        clockwise: false)
            layer.fillColor = nil
            layer.strokeColor = color.cgColor
            layer.lineWidth = lineWidth
        case .ringTwoHalfHorizontal:
            path.appendArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius: size.width / 2,
                        startAngle: 135,
                        endAngle: 225,
                        clockwise: false)
            path.move(
                to: CGPoint(x: size.width / 2 + size.width / 2 * CGFloat(cos(7 * Double.pi / 4)),
                            y: size.height / 2 + size.height / 2 * CGFloat(sin(7 * Double.pi / 4)))
            )
            path.appendArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius: size.width / 2,
                        startAngle: 315,
                        endAngle: 45,
                        clockwise: false)
            layer.fillColor = nil
            layer.strokeColor = color.cgColor
            layer.lineWidth = lineWidth
        case .ringThirdFour:
            path.appendArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius: size.width / 2,
                        startAngle: 315,
                        endAngle: 225,
                        clockwise: false)
            layer.fillColor = nil
            layer.strokeColor = color.cgColor
            layer.lineWidth = 2
        case .rectangle:
            path.move(to: CGPoint(x: 0, y: 0))
            path.line(to: CGPoint(x: size.width, y: 0))
            path.line(to: CGPoint(x: size.width, y: size.height))
            path.line(to: CGPoint(x: 0, y: size.height))
            layer.fillColor = color.cgColor
        case .triangle:
            let offsetY = size.height / 4
            
            path.move(to: CGPoint(x: 0, y: size.height - offsetY))
            path.line(to: CGPoint(x: size.width / 2, y: size.height / 2 - offsetY))
            path.line(to: CGPoint(x: size.width, y: size.height - offsetY))
            path.close()
            layer.fillColor = color.cgColor
        case .line:
            path.appendRoundedRect(CGRect(x: 0, y: 0, width: size.width, height: size.height), xRadius: size.width / 2, yRadius: size.width / 2)
            layer.fillColor = color.cgColor
        case .pacman:
            path.appendArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius: size.width / 4,
                        startAngle: 0,
                        endAngle: 360,
                        clockwise: false)
            layer.fillColor = nil
            layer.strokeColor = color.cgColor
            layer.lineWidth = size.width / 2
        }
        
        layer.backgroundColor = nil
        layer.path = path.cgPath
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        return layer
    }
}
