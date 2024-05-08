//
//  LoadingFooterTableView.swift
//  QiscusSampleChat
//
//  Created by Admin on 05/05/24.
//

import UIKit

class LoadingFooterTableView: BaseCustomView {
  
    let progressView = CircelIndetermineProgressView(frame: CGRect(
      origin: .zero,
      size: CGSize(width: Dimens.roomListProgressSize, height: Dimens.roomListProgressSize)
    ))
 
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }
  
  override var intrinsicContentSize: CGSize {
    return CGSize(width: UIView.noIntrinsicMetric, height: Dimens.roomListHeight)
  }
  
  private func commonInit() {
    progressView.translatesAutoresizingMaskIntoConstraints = false
    progressView.accessibilityIdentifier = "progressView"
    
    addSubview(progressView)
    
    activatedWithConstraint([
      progressView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      progressView.topAnchor.constraint(equalTo: self.topAnchor, constant: Dimens.smaller),
      progressView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Dimens.smaller),
      progressView.widthAnchor.constraint(equalToConstant: Dimens.roomListProgressSize),
      progressView.heightAnchor.constraint(equalToConstant: Dimens.roomListProgressSize)
    ])
  }
}

