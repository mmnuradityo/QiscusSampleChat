//
//  ChatViewController.swift
//  QisusSampleChat
//
//  Created by Admin on 24/04/24.
//

import UIKit

class ChatViewController: BaseViewController {
  
  let stackView = UIStackView()
  let lable = UILabel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    style()
    layout()
  }
}

// MARK: - setup and layouting
extension ChatViewController {
  
  func setup() {
    navigationItem.leftBarButtonItem = barBtnBack()
    
  }
  
  func style() {
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.spacing = 20
    
    lable.translatesAutoresizingMaskIntoConstraints = false
    lable.text = "Welcome to chat"
    lable.font = UIFont.preferredFont(forTextStyle: .title1)
  }
  
  func layout() {
    stackView.addArrangedSubview(lable)
    
    view.addSubview(stackView)
    
    NSLayoutConstraint.activate([
      stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
    
  }
}
