//
//  FooterTableView.swift
//  QiscusSampleChat
//
//  Created by Admin on 27/04/24.
//

import UIKit

class ChatFooterTableView: BaseCustomView {
  
  let headerLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }
  
  override var intrinsicContentSize: CGSize {
    return CGSize(width: UIView.noIntrinsicMetric, height: 35)
  }
  
  private func commonInit() {
    transform = CGAffineTransform(scaleX: 1, y: -1)
    
    headerLabel.translatesAutoresizingMaskIntoConstraints = false
    headerLabel.accessibilityIdentifier = "headerLabel"
    headerLabel.text = "You've reached first page"
    headerLabel.textColor = Colors.systemColor
    headerLabel.font = UIFont(name: Fonts.interRegular, size: Fonts.defaultSize)
    
    addSubview(headerLabel)
    
    activatedWithConstraint([
      headerLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      headerLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
    ])
  }
}
