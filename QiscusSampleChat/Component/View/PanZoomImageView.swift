//
//  PanZoomImageView.swift
//  QiscusSampleChat
//
//  Created by Admin on 09/05/24.
//

import UIKit

class PanZoomImageView: UIScrollView {
  
  let imageView = UIImageView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }
  
  private func commonInit() {
    // Setup image view
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFit
    addSubview(imageView)
    NSLayoutConstraint.activate([
      imageView.widthAnchor.constraint(equalTo: widthAnchor),
      imageView.heightAnchor.constraint(equalTo: heightAnchor),
      imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
      imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
    
    // Setup scroll view
    minimumZoomScale = 1
    maximumZoomScale = 3
    showsHorizontalScrollIndicator = false
    showsVerticalScrollIndicator = false
    delegate = self
    
    // Setup tap gesture
    let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
    doubleTapRecognizer.numberOfTapsRequired = 2
    addGestureRecognizer(doubleTapRecognizer)
  }
  
}

extension PanZoomImageView: UIScrollViewDelegate {
  
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
  
  @objc private func handleDoubleTap(_ sender: UITapGestureRecognizer) {
    if zoomScale == 1 {
      setZoomScale(2, animated: true)
    } else {
      setZoomScale(1, animated: true)
    }
  }
  
}
