//
//  BsseViewController.swift
//  QiscusSampleChat
//
//  Created by Admin on 21/04/24.
//

import UIKit

open class BaseViewController: UIViewController {
  
  var dismissGesture: UITapGestureRecognizer?
  var tapOutsideDelegate: TapOutsideDelegate?
  
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
  
  func activatedWithConstraint(_ constraints: [NSLayoutConstraint]) {
    NSLayoutConstraint.activate(constraints)
  }
  
  public func barBtnBack() -> UIBarButtonItem {
    return UIBarButtonItem(
      title: "back",
      image: UIImage(named: Images.backArrow)?.withTintColor(.white),
      target: self,
      action: #selector(backAction)
    )
  }
  
  @objc public func backAction() {
    self.dismiss(animated: true, completion: nil)
  }
  
  // MARK: - Dismiss OutsideGestureDelegate
  protocol TapOutsideDelegate {
    func handleTapOutside()
  }
  
}

// MARK: - Dismiss OutsideGesture
extension BaseViewController {
  
  func addDismissGesture() {
    dismissGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_ : )))
    view.addGestureRecognizer(dismissGesture!)
  }
  
  func removeDismissGesture() {
    if let dismissTap = self.dismissGesture {
      view.removeGestureRecognizer(dismissTap)
      self.dismissGesture = nil
    }
  }
  
  @objc func viewTapped(_ recognizer: UITapGestureRecognizer) {
    view.endEditing(true)
    tapOutsideDelegate?.handleTapOutside()
  }
  
}

