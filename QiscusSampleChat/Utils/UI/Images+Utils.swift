//
//  Image+Utils.swift
//  QiscusSampleChat
//
//  Created by Admin on 22/04/24.
//

import UIKit

extension UIImage {
  convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
    let rect = CGRect(origin: .zero, size: size)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
    color.setFill()
    UIRectFill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    guard let cgImage = image?.cgImage else { return nil }
    self.init(cgImage: cgImage)
  }
  
  func rounded(radius: CGFloat) -> UIImage {
    let rect = CGRect(origin: .zero, size: size)
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    UIBezierPath(roundedRect: rect, cornerRadius: radius).addClip()
    draw(in: rect)
    return UIGraphicsGetImageFromCurrentImageContext()!
  }
  
}

extension UIImageView {
  
  func isLoadImage(imageState: ImageModel.State?, dataImage: Data?) -> Bool {
    if let imageState = imageState, imageState != .new {
      self.image = (dataImage != nil)
      ? UIImage(data: dataImage!) : UIImage(named: Images.chatPlaceholder)!
      return false
    }
    
    return true
  }
  
}
