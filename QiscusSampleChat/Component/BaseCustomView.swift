//
//  BaseCustomView.swift
//  QiscusSampleChat
//
//  Created by Admin on 24/04/24.
//

import UIKit

open class BaseCustomView: UIView {
  
  func addToStackView(_ stackView: UIStackView, views: UIView...) {
    for view in views {
      stackView.addArrangedSubview(view)
    }
    self.addSubview(stackView)
  }
  
  func addToView(_ views: UIView...) {
    for view in views {
      self.addSubview(view)
    }
  }
  
  func activatedWithConstraint(_ constraints: [NSLayoutConstraint]) {
    NSLayoutConstraint.activate(constraints)
  }
  
}
