//
//  PopupOptionsMenuView.swift
//  QiscusSampleChat
//
//  Created by Admin on 03/05/24.
//

import UIKit

class PopupOptionsMenuView: BaseCustomView {
  
  let logoutButton = UIButton()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    style()
    layout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override var intrinsicContentSize: CGSize {
    return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
  }
}

extension PopupOptionsMenuView {
  
  func style() {
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .white
    layer.cornerRadius = Dimens.smallest
    // Set shadow color
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.2
    layer.shadowOffset = CGSize(width: 0, height: 1)
    layer.shouldRasterize = true
    layer.shadowRadius = Dimens.extraSmall
    layer.masksToBounds = false
    
    logoutButton.accessibilityIdentifier = "logoutButton"
    logoutButton.setupMenuButton(imageIcon: Images.menuOptionsLogin, title: "Logout")
  }
  
  func layout() {
    addToView(logoutButton)
    
    activatedWithConstraint([
      logoutButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Dimens.smaller),
      trailingAnchor.constraint(equalTo: logoutButton.trailingAnchor, constant: Dimens.smaller),
      logoutButton.topAnchor.constraint(equalTo: topAnchor, constant: Dimens.smallest),
      bottomAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: Dimens.smallest)
    ])
  }
}
extension PopupOptionsMenuView {
  
  func show(at viewtarget: UIView, in rootView: UIView) {
    rootView.addSubview(self)
    
    activatedWithConstraint([
      viewtarget.trailingAnchor.constraint(equalTo: trailingAnchor),
      topAnchor.constraint(equalTo: viewtarget.bottomAnchor, constant: Dimens.smallest)
    ])
    
    alpha = 0
    UIView.animate(withDuration: 0.3) {
      self.alpha = 1
    }
  }
  
  func hide(in rootView: UIView) {
    rootView.willRemoveSubview(self)
    UIView.animate(withDuration: 0.3) {
      self.alpha = 0
    }
  }
}
