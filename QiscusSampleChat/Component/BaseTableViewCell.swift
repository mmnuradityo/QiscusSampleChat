//
//  BaseTableViewCell.swift
//  QiscusSampleChat
//
//  Created by Admin on 04/05/24.
//

import UIKit

open class BaseTableViewCell: UITableViewCell {
  
  func addToStackView(_ stackView: UIStackView, views: UIView...) {
    for view in views {
      stackView.addArrangedSubview(view)
    }
    contentView.addSubview(stackView)
  }
  
  func addToView(_ views: [UIView]) {
    for view in views {
      contentView.addSubview(view)
    }
  }
  
  func activatedWithConstraint(_ constraints: [NSLayoutConstraint]) {
    NSLayoutConstraint.activate(constraints)
  }
  
}
