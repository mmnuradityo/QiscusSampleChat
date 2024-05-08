//
//  CircularProgressView.swift
//  QiscusSampleChat
//
//  Created by Admin on 06/05/24.
//

import UIKit

class CircularProgressView: UIView {
  
  private var circleLayer = CAShapeLayer()
  private var progressLayer = CAShapeLayer()
  private var startPoint = CGFloat(-Double.pi / 2)
  private var endPoint = CGFloat(3 * Double.pi / 2)
  var strokeBackgroundColor = Colors.strokeColor
  var strokeColor = Colors.primaryColor
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    let center = CGPoint(x: bounds.midX, y: bounds.midY)
    let radius = min(bounds.width, bounds.height) / 2 - 2
    
    let circularPath = UIBezierPath(
      arcCenter: CGPointZero,
      radius: radius,
      startAngle: CGFloat(Double.pi),
      endAngle: CGFloat(Double.pi + (2 * Double.pi)),
      clockwise: true
    )
    
    circleLayer.position = center
    circleLayer.path = circularPath.cgPath
    circleLayer.fillColor = UIColor.clear.cgColor
    circleLayer.lineCap = .round
    circleLayer.lineWidth = 4.0
    circleLayer.strokeEnd = 1.0
    circleLayer.strokeColor = strokeBackgroundColor.cgColor
    
    progressLayer.position = center
    progressLayer.path = circularPath.cgPath
    progressLayer.fillColor = UIColor.clear.cgColor
    progressLayer.lineCap = .round
    progressLayer.lineWidth = 3.0
    progressLayer.strokeEnd = 0
    progressLayer.strokeColor = strokeColor.cgColor
    
    layer.addSublayer(circleLayer)
    layer.addSublayer(progressLayer)
  }
  
  func progressAnimation(progress: Float) {
    let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
    circularProgressAnimation.duration = 0.2
    circularProgressAnimation.toValue = progress
    circularProgressAnimation.fillMode = .forwards
    circularProgressAnimation.isRemovedOnCompletion = false
    
    progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
  }
  
}
