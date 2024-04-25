//
//  BsseViewController.swift
//  QiscusSampleChat
//
//  Created by Admin on 21/04/24.
//

import UIKit

open class BaseViewController: UIViewController {
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    setupDismissKeyboardGesture()
  }
  
  func addToStackView(_ stackView: UIStackView, views: UIView...) {
    for view in views {
      stackView.addArrangedSubview(view)
    }
    self.view.addSubview(stackView)
  }
  
  func addToView(_ views: UIView...) {
    for view in views {
      self.view.addSubview(view)
    }
  }
  
  func activatedWithConstrain(_ constraints: [NSLayoutConstraint]) {
    NSLayoutConstraint.activate(constraints)
  }
  
  public func barBtnBack() -> UIBarButtonItem {
    return UIBarButtonItem(
      title: "back",
      image: UIImage(systemName: "arrow.backward"),
      target: self,
      action: #selector(backAction)
    )
  }
  
  @objc public func backAction() {
    dismiss(animated: true, completion: nil)
  }
  
}

// MARK: - Dismiss Keyboard
extension BaseViewController {
  
  private func setupDismissKeyboardGesture() {
    let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_ : )))
    view.addGestureRecognizer(dismissKeyboardTap)
  }
  
  @objc func viewTapped(_ recognizer: UITapGestureRecognizer) {
    view.endEditing(true) // resign first responder
  }
  
}
