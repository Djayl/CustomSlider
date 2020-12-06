//
//  CustomSlider.swift
//  testslider
//
//  Created by MacBook DS on 06/12/2020.
//

import Foundation
import UIKit


final public class CustomSlider: UIControl {
    
    public var sliderRange: CGFloat = 1
    
    public var currentValue: CGFloat = 0.0
    
    // MARK: - Private Properties
    
    private let thumbSize: CGFloat = 24
    
    private var margin: CGFloat { return (thumbSize * 0.5) + 2}
    
    private var touchStart: CGPoint = .zero
    
    private let lineWidth: CGFloat = 4
    
    /// Label to display above the thumb
    private let sliderValueLabel = UILabel()
    
    private var sliderValue: CGFloat = 0.5 {
        didSet {
            setNeedsDisplay()
        }
    }
    /// Thumb to draw
    private var thumbPath: UIBezierPath?
    
    /// Draw the elements of the slider to be displayed
    public override func draw(_ rect: CGRect) {
        
        let halfBoundsHeight: CGFloat = bounds.height * 0.5
        let halfBoundsWidth: CGFloat = bounds.width * 0.5
        let widthMargins: CGFloat = margin * 2
        roundSliderValue()
        /// Variable Declarations
        let circleOffset: CGFloat = sliderValue * (bounds.width - widthMargins) + 2
        let bezierEndpoint: CGFloat = sliderValue * (bounds.width - widthMargins) + margin
        
        /// Background line Drawing
        let backgroundLinePath = UIBezierPath()
        backgroundLinePath.move(to: CGPoint(x: bounds.minX + margin, y: bounds.minY + 0.5 * bounds.height))
        backgroundLinePath.addLine(to: CGPoint(x: bounds.maxX - margin, y: bounds.minY + 0.5 * bounds.height))
        UIColor.lightGray.setStroke()
        backgroundLinePath.lineWidth = lineWidth
        backgroundLinePath.lineCapStyle = .round
        backgroundLinePath.stroke()
        
        /// Line Drawing
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: halfBoundsWidth, y: halfBoundsHeight))
        linePath.addLine(to: CGPoint(x: bezierEndpoint, y: halfBoundsHeight))
        setColor().setStroke()
        linePath.lineWidth = lineWidth
        linePath.stroke()
        
        /// Center mark Drawing
        let centerPath = UIBezierPath()
        centerPath.move(to: CGPoint(x: halfBoundsWidth, y: halfBoundsHeight - lineWidth * 2))
        centerPath.addLine(to: CGPoint(x: halfBoundsWidth, y: halfBoundsHeight + lineWidth * 2))
        setColor().setStroke()
        centerPath.lineWidth = lineWidth
        centerPath.lineCapStyle = .round
        centerPath.stroke()
        
        /// Thumb Drawing
        thumbPath = UIBezierPath(ovalIn: CGRect(x: circleOffset, y: (halfBoundsHeight) - (thumbSize * 0.5), width: thumbSize, height: thumbSize))
        setColor().setStroke()
        thumbPath?.lineWidth = lineWidth
        UIColor.white.setFill()
        thumbPath?.fill()
        thumbPath?.stroke()
        setupSliderValueLabelInterface(thumbPath)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let loc = touches.first?.location(in: self) else { return }
        touchStart = loc
        update(loc)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let loc = touches.first?.location(in: self) else { return }
        update(loc)
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let loc = touches.first?.location(in: self) else { return }
        update(loc)
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let loc = touches.first?.location(in: self) else { return }
        update(loc)
    }
    
    init(sliderRange: CGFloat) {
        super.init(frame: .zero)
        self.sliderRange = sliderRange
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Extension

private extension CustomSlider {
    
    func setup() {
        backgroundColor = .clear
        setupSliderValueLabel()
    }
    
    func update(_ location: CGPoint) {
        sliderValue = max(min((location.x - margin) / (bounds.width - (margin)), 1), 0)
        currentValue = sliderValue - 0.5
        sendActions(for: .valueChanged)
    }
    
    func setupSliderValueLabel() {
        sliderValueLabel.backgroundColor = .clear
        sliderValueLabel.font = UIFont(name: "Futura Medium", size: 15)
        sliderValueLabel.textAlignment = .center
        sliderValueLabel.textColor = .systemBlue
        self.addSubview(sliderValueLabel)
    }
    
    func setupSliderValueLabelInterface(_ thumbPath: UIBezierPath?) {
        sliderValueLabel.frame.size = sliderValueLabel.intrinsicContentSize
        guard let thumbPath = thumbPath else  { return }
        setupSliderValueLabelPosition(thumbPath, label: sliderValueLabel)
        sliderValueLabel.textColor = setColor()
    }
    
    func roundSliderValue() {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 1
        let value = currentValue * sliderRange
        if let formattedString = formatter.string(for: value) {
            sliderValueLabel.text = formattedString
        }
    }
    
    func setupSliderValueLabelPosition(_ thumbPath: UIBezierPath, label: UILabel) {
        let halfLabelWidth = CGFloat(label.frame.width / 2)
        let minX = halfLabelWidth
        let maxX = CGFloat(frame.width - halfLabelWidth)
        let thumbX = thumbPath.currentPoint.x - margin
        let x = max(minX, min(thumbX, maxX))
        label.center = CGPoint(x: x, y: thumbPath.currentPoint.y - margin - 16)
    }
    
    func setColor() -> UIColor {
        switch currentValue {
        case let x where x < 0:
            return UIColor.systemRed
        case let x where x > 0:
            return UIColor.systemGreen
        default:
            return UIColor.lightGray
        }
    }
}
