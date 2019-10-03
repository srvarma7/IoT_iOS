//
//  GuageView.swift
//  UIGauge
//
//  Created by Ganesh Kanchibhotla on 2/10/19.
//  Copyright © 2019 monash. All rights reserved.
//

import UIKit

class GaugeView: UIView {
    
    let valueLabel = UILabel()
    var valueFont = UIFont.systemFont(ofSize: 12)
    var valueColor = UIColor.gray
    
    var segmentWidth: CGFloat = 20
    var segmentColors = [UIColor(red: 0, green: 1, blue: 0, alpha: 1), UIColor(red: 0.2, green: 0.8, blue: 0, alpha: 1), UIColor(red: 0.5, green: 0.5, blue: 0, alpha: 0.7), UIColor(red: 0.8, green: 0.2, blue: 0, alpha: 0.7), UIColor(red: 1, green: 0, blue: 0, alpha: 1)]
    
    var totalAngle: CGFloat = 270
    var rotation: CGFloat = -135
    
    var outerCenterDiscColor = UIColor(white: 0.9, alpha: 1)
    var outerCenterDiscWidth: CGFloat = 35
    var innerCenterDiscColor = UIColor(white: 0.7, alpha: 1)
    var innerCenterDiscWidth: CGFloat = 25
    
    var majorTickColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    var majorTickWidth: CGFloat = 1.5
    var majorTickLength: CGFloat = 20
    
    var minorTickColor = UIColor.black.withAlphaComponent(0.1)
    var minorTickWidth: CGFloat = 0.7
    var minorTickLength: CGFloat = 20
    var minorTickCount = 3
    
    var needleColor = UIColor(white: 0.7, alpha: 1)
    var needleWidth: CGFloat = 2
    let needle = UIView()
    
    var outerBezelColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
    var outerBezelWidth: CGFloat = 5
    var innerBezelColor = UIColor.white
    var innerBezelWidth: CGFloat = 5
    
    var insideColor = UIColor.white
    
    var value: Int = 0 {
        didSet {
            //valueLabel.text = String(value)
            print(valueLabel.text)
            let needlePosition = CGFloat(value) / 100
            let movefrom = rotation
            let moveTo = rotation + totalAngle
            let needleRotation = movefrom + (moveTo - movefrom) * needlePosition
            needle.transform = CGAffineTransform(rotationAngle: deg2rad(needleRotation))
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        drawBackground(in: rect, context: context)
        drawTicks(in: rect, context: context)
        drawCenterDisc(in: rect, context: context)
    }
    
    func drawBackground(in rect: CGRect, context: CGContext) {

        outerBezelColor.set()
        context.fillEllipse(in: rect)
        
        let innerBezelRect = rect.insetBy(dx: outerBezelWidth, dy: outerBezelWidth)
        innerBezelColor.set()
        context.fillEllipse(in: innerBezelRect)
        
        let insideRect = innerBezelRect.insetBy(dx: innerBezelWidth, dy: innerBezelWidth)
        insideColor.set()
        context.fillEllipse(in: insideRect)
        
        drawSegments(in: rect, context: context)
    }
    
    func drawCenterDisc(in rect: CGRect, context: CGContext) {
        context.saveGState()
        context.translateBy(x: rect.midX, y: rect.midY)
        
        let outerCenterRect = CGRect(x: -outerCenterDiscWidth / 2, y: -outerCenterDiscWidth / 2, width: outerCenterDiscWidth, height: outerCenterDiscWidth)
        outerCenterDiscColor.set()
        context.fillEllipse(in: outerCenterRect)
        
        let innerCenterRect = CGRect(x: -innerCenterDiscWidth / 2, y: -innerCenterDiscWidth / 2, width: innerCenterDiscWidth, height: innerCenterDiscWidth)
        innerCenterDiscColor.set()
        context.fillEllipse(in: innerCenterRect)
        context.restoreGState()
    }
    
    func drawSegments(in rect: CGRect, context: CGContext) {

        context.saveGState()
        context.translateBy(x: rect.midX, y: rect.midY)
        context.rotate(by: deg2rad(rotation) - (.pi / 2))
        context.setLineWidth(segmentWidth)
        
        let segmentAngle = deg2rad(totalAngle / CGFloat(segmentColors.count))
        let segmentRadius = (((rect.width - segmentWidth) / 2) - outerBezelWidth) - innerBezelWidth
        
        for (index, segment) in segmentColors.enumerated() {
           
            let start = CGFloat(index) * segmentAngle
            segment.set()
            context.addArc(center: .zero, radius: segmentRadius, startAngle: start, endAngle: start + segmentAngle, clockwise: false)
            context.drawPath(using: .stroke)
        }
        
        context.restoreGState()
    }
    
    func drawTicks(in rect: CGRect, context: CGContext) {

        context.saveGState()
        context.translateBy(x: rect.midX, y: rect.midY)
        context.rotate(by: deg2rad(rotation) - (.pi / 2))
        
        let segmentAngle = deg2rad(totalAngle / CGFloat(segmentColors.count))
        let segmentRadius = (((rect.width - segmentWidth) / 2) - outerBezelWidth) - innerBezelWidth
        
        context.saveGState()
        
        context.setLineWidth(majorTickWidth)
        majorTickColor.set()
        let majorEnd = segmentRadius + (segmentWidth / 2)
        let majorStart = majorEnd - majorTickLength
        for _ in 0 ... segmentColors.count {
            context.move(to: CGPoint(x: majorStart, y: 0))
            context.addLine(to: CGPoint(x: majorEnd, y: 0))
            context.drawPath(using: .stroke)
            context.rotate(by: segmentAngle)
        }
        context.restoreGState()
        
        context.saveGState()
        
        context.setLineWidth(minorTickWidth)
        minorTickColor.set()
        let minorEnd = segmentRadius + (segmentWidth / 2)
        let minorStart = minorEnd - minorTickLength
        let minorTickSize = segmentAngle / CGFloat(minorTickCount + 1)
        for _ in 0 ..< segmentColors.count {
            
            context.rotate(by: minorTickSize)
            
            for _ in 0 ..< minorTickCount {
                context.move(to: CGPoint(x: minorStart, y: 0))
                context.addLine(to: CGPoint(x: minorEnd, y: 0))
                context.drawPath(using: .stroke)
                context.rotate(by: minorTickSize)
            }
        }
        context.restoreGState()
        context.restoreGState()
    }
    
    func deg2rad(_ number: CGFloat) -> CGFloat {
        return number * .pi / 180
    }
    
    func setUp() {
        
        valueLabel.font = valueFont
        valueLabel.text = "100"
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            valueLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
        
        needle.backgroundColor = needleColor
        needle.translatesAutoresizingMaskIntoConstraints = false
        needle.bounds = CGRect(x: 0, y: 0, width: needleWidth, height: bounds.height / 3)
        needle.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        needle.center = CGPoint(x: bounds.midX, y: bounds.midY)
        addSubview(needle)
    }
}
//    func drawneedle(){
//        let triangleLayer = CAShapeLayer()
//        let shadowLayer = CAShapeLayer()
//
//        // 2
//        triangleLayer.frame = bounds
//        shadowLayer.frame = CGRect(x: bounds.origin.x, y: bounds.origin.y + 5, width: bounds.width, height: bounds.height)
//
//        // 3
//        let needlePath = UIBezierPath()
//        needlePath.move(to: CGPoint(x: self.bounds.width/2, y: self.bounds.width * 0.95))
//        needlePath.addLine(to: CGPoint(x: self.bounds.width * 0.47, y: self.bounds.width * 0.42))
//        needlePath.addLine(to: CGPoint(x: self.bounds.width * 0.53, y: self.bounds.width * 0.42))
//
//        needlePath.close()
//
//        // 4
//        triangleLayer.path = needlePath.cgPath
//        shadowLayer.path = needlePath.cgPath
//
//        // 5
//        triangleLayer.fillColor = needleColor.cgColor
//        triangleLayer.strokeColor = needleColor.cgColor
//        // 6
//        layer.addSublayer(shadowLayer)
//        layer.addSublayer(triangleLayer)
//
//        var firstAngle = radians(for: 0)
//
//        let degrees:CGFloat = 3.6 * 100 // Entire Arc is of 240 degrees
//        let radians = degrees * .pi/(1.8*100)
//
//        let thisRadians = (arcAngle * 100) * .pi/(1.8*100)
//        let theD = (radians - thisRadians)/2
//        firstAngle += theD
//        let needleValue = radians(for: self.needleValue) + firstAngle
//        animate(triangleLayer: triangleLayer, shadowLayer: shadowLayer, fromValue: 0, toValue: needleValue*1.05, duration: 0.5) {
//            self.animate(triangleLayer: triangleLayer, shadowLayer: shadowLayer, fromValue: needleValue*1.05, toValue: needleValue*0.95, duration: 0.4, callBack: {
//                self.animate(triangleLayer: triangleLayer, shadowLayer: shadowLayer, fromValue: needleValue*0.95, toValue: needleValue, duration: 0.6, callBack: {})
//    }
