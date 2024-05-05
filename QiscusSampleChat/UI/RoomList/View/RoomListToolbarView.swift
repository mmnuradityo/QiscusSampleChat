//
//  RoomListToolbarView.swift
//  QiscusSampleChat
//
//  Created by Admin on 04/05/24.
//

import UIKit

class RoomListToolbarView: BaseCustomView {
  
  let logoImageView = UIImageView()
  let titleLable = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    style()
    layout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override var intrinsicContentSize: CGSize {
    return CGSize(width: UIScreen.main.bounds.width, height: Dimens.toolbarHeight)
  }
  
}

// MARK: - setup and layouting
extension RoomListToolbarView {
  
  func style() {
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = Colors.primaryColor
    
    logoImageView.translatesAutoresizingMaskIntoConstraints = false
    logoImageView.accessibilityIdentifier = "logoImageView"
    logoImageView.image = UIImage(named: Images.qiscusLogo)?.withTintColor(.white)
    
    titleLable.translatesAutoresizingMaskIntoConstraints = false
    titleLable.accessibilityIdentifier = "titleLable"
    titleLable.font = UIFont(name: Fonts.interSemiBold, size: Fonts.toolbarTitleSize)
    titleLable.textColor = .white
    titleLable.text = "Room List"
  }
  
  func layout() {
    addToView(logoImageView, titleLable)
    
    activatedWithConstraint([
      logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Dimens.smaller),
      logoImageView.heightAnchor.constraint(equalToConstant: Images.toolbarIconHeight),
      logoImageView.widthAnchor.constraint(equalToConstant: Images.toolbarIconWidth),
      
      titleLable.centerXAnchor.constraint(equalTo: centerXAnchor),
      titleLable.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
  
}
