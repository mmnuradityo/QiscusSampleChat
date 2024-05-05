//
//  ChatMenuView.swift
//  QiscusSampleChat
//
//  Created by Admin on 25/04/24.
//

import UIKit

class ChatMenuView: BaseCustomView {
  
  let cameraButton = UIButton(type: .custom)
  let galleryButton = UIButton(type: .custom)
  let fileButton = UIButton(type: .custom)
  let stackView = UIStackView()
  let outsideView = UIView()
  
  var delegate: ChatMenuViewDelegate?
  
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

// MARK: - setup and layouting
extension ChatMenuView {
  
  func style() {
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .darkGray.withAlphaComponent(0.6)
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.accessibilityIdentifier = "stackView"
    stackView.axis = .vertical
    stackView.alignment = .leading
    stackView.distribution = .fillEqually
    stackView.layer.cornerRadius = Dimens.smaller
    stackView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    stackView.spacing = 20
    stackView.backgroundColor = .white
    stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
      top: Dimens.medium, leading: Dimens.medium, bottom: Dimens.medium, trailing: Dimens.medium
    )
    stackView.isLayoutMarginsRelativeArrangement = true
    
    cameraButton.accessibilityIdentifier = "cameraButton"
    cameraButton.setupMenuButton(imageIcon: Images.menuCamera, title: "Camera")
    cameraButton.addTarget(self, action: #selector(cameraButtonDidTapped), for: .touchUpInside)
    
    galleryButton.accessibilityIdentifier = "galleryButton"
    galleryButton.setupMenuButton(imageIcon: Images.menuGallery, title: "Gallery")
    galleryButton.addTarget(self, action: #selector(galleryButtonDidTapped), for: .touchUpInside)
    
    fileButton.accessibilityIdentifier = "fileButton"
    fileButton.setupMenuButton(imageIcon: Images.manuFile, title: "File")
    fileButton.addTarget(self, action: #selector(fileButtonDidTapped), for: .touchUpInside)
    
    outsideView.translatesAutoresizingMaskIntoConstraints = false
    outsideView.accessibilityIdentifier = "outsideView"
    let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(outsideDidTapped))
    gesture.numberOfTapsRequired = 1
    outsideView.isUserInteractionEnabled = true
    outsideView.addGestureRecognizer(gesture)
  }
  
  func layout() {
    addToStackView(
      stackView, views: cameraButton, galleryButton, fileButton
    )
    addToView(outsideView)
    
    activatedWithConstraint([
      cameraButton.heightAnchor.constraint(equalToConstant: Images.iconSize),
      galleryButton.heightAnchor.constraint(equalToConstant: Images.iconSize),
      fileButton.heightAnchor.constraint(equalToConstant: Images.iconSize),
      
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
      
      outsideView.topAnchor.constraint(equalTo: topAnchor),
      outsideView.bottomAnchor.constraint(equalTo: stackView.topAnchor),
      outsideView.leadingAnchor.constraint(equalTo: leadingAnchor),
      trailingAnchor.constraint(equalTo: outsideView.trailingAnchor)
    ])
  }
}

// MARK: ~ Action
extension ChatMenuView {
  @objc func cameraButtonDidTapped() {
    delegate?.cameraButtonDidTapped()
  }
  
  @objc func galleryButtonDidTapped() {
    delegate?.galleryButtonDidTapped()
  }
  
  @objc func fileButtonDidTapped() {
    delegate?.fileButtonDidTapped()
  }
  
  @objc func outsideDidTapped() {
    delegate?.outsideDidTapped()
  }
}

protocol ChatMenuViewDelegate {
  func cameraButtonDidTapped()
  
  func galleryButtonDidTapped()
  
  func fileButtonDidTapped()
  
  func outsideDidTapped()
}
