//
//  CircelProgressView.swift
//  QiscusSampleChat
//
//  Created by Admin on 05/05/24.
//

import UIKit

class CircelIndetermineProgressView: UIView, CAAnimationDelegate {
  
  let circularLayer = CAShapeLayer()
  var strokeColor = Colors.primaryColor
  
  let inAnimation: CAAnimation = {
    let animation = CABasicAnimation(keyPath: "strokeEnd")
    animation.fromValue = 0.0
    animation.toValue = 1.0
    animation.duration = 1.0
    animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
    
    return animation
  }()
  
  let outAnimation: CAAnimation = {
    let animation = CABasicAnimation(keyPath: "strokeStart")
    animation.beginTime = 0.5
    animation.fromValue = 0.0
    animation.toValue = 1.0
    animation.duration = 1.0
    animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
    
    return animation
  }()
  
  let rotationAnimation: CAAnimation = {
    let animation = CABasicAnimation(keyPath: "transform.rotation.z")
    animation.fromValue = 0.0
    animation.toValue = 2 * Double.pi
    animation.duration = 2.0
    animation.repeatCount = MAXFLOAT
    
    return animation
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    circularLayer.lineWidth = 4.0
    circularLayer.fillColor = nil
    layer.addSublayer(circularLayer)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let center = CGPoint(x: bounds.midX, y: bounds.midY)
    let radius = min(bounds.width, bounds.height) / 2 - circularLayer.lineWidth / 2
    
    let arcPath = UIBezierPath(
      arcCenter: CGPointZero,
      radius: radius,
      startAngle: CGFloat(Double.pi),
      endAngle: CGFloat(Double.pi + (2 * Double.pi)),
      clockwise: true
    )
    
    circularLayer.position = center
    circularLayer.path = arcPath.cgPath
    circularLayer.strokeColor = strokeColor.cgColor
    
    animateProgressView()
    circularLayer.add(rotationAnimation, forKey: "rotateAnimation")
  }
  
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    if(flag) {
      animateProgressView()
    }
  }
  
  func animateProgressView() {
    circularLayer.removeAnimation(forKey: "strokeAnimation")
    
    let strokeAnimationGroup = CAAnimationGroup()
    strokeAnimationGroup.duration = 1.0 + outAnimation.beginTime
    strokeAnimationGroup.repeatCount = 1
    strokeAnimationGroup.animations = [inAnimation, outAnimation]
    strokeAnimationGroup.delegate = self
    
    circularLayer.add(strokeAnimationGroup, forKey: "strokeAnimation")
  }
  
}
