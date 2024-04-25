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
    backgroundColor = .darkGray.withAlphaComponent(0.5)
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
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
    
    setupMenuButton(
      targetButton: cameraButton, imageIcon: Images.camera, title: "Camera"
    )
    cameraButton.addTarget(self, action: #selector(cameraButtonDidTapped), for: .touchUpInside)
    
    setupMenuButton(
      targetButton: galleryButton, imageIcon: Images.gallery, title: "Gallery"
    )
    galleryButton.addTarget(self, action: #selector(galleryButtonDidTapped), for: .touchUpInside)
    
    setupMenuButton(
      targetButton: fileButton, imageIcon: Images.file, title: "File"
    )
    fileButton.addTarget(self, action: #selector(fileButtonDidTapped), for: .touchUpInside)
    
    outsideView.translatesAutoresizingMaskIntoConstraints = false
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
    
    activatedWithConstrain([
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

// MARK: ~ view logic
extension ChatMenuView {
  
  func setupMenuButton(targetButton: UIButton, imageIcon: String, title: String) {
    targetButton.translatesAutoresizingMaskIntoConstraints = false
    targetButton.setImage(UIImage(named: imageIcon), for: .normal)
    targetButton.setTitle(title, for: .normal)
    targetButton.setTitleColor(.black, for: .normal)
    targetButton.setTitleColor(Colors.primaryColor, for: .highlighted)
    targetButton.titleLabel?.font = UIFont(
      name: Fonts.interRegular, size: Fonts.formSize
    )
    targetButton.configuration = configureButton()
  }
  
  func configureButton() -> UIButton.Configuration {
    var buttonConfiguration = UIButton.Configuration.borderless()
    buttonConfiguration.imagePadding = Dimens.smaller
    buttonConfiguration.contentInsets = NSDirectionalEdgeInsets(
      top: 0, leading: 0, bottom: 0, trailing: 0
    )
    return buttonConfiguration
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
