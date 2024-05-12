//
//  ImagePreviewViewController.swift
//  QiscusSampleChat
//
//  Created by Admin on 07/05/24.
//

import UIKit

class ImagePreviewViewController: BaseViewController {
  
  static func instantiate(message: MessageModel, _ delegate: ImagePreviewViewDelegate) -> UINavigationController {
    let viewController = ImagePreviewViewController(message: message, delegate: delegate)
    viewController.view.accessibilityIdentifier = "imagePreviewViewController"
    
    let navigationController = UINavigationController(rootViewController: viewController)
    navigationController.modalPresentationStyle = .fullScreen
    return navigationController
  }
  
  let titleLabe: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: Fonts.interSemiBold, size: Fonts.toolbarTitleSize)
    label.textColor = .white
    label.text = "Image Preview"
    return label
  }()
  let zoomableImageView = PanZoomImageView()
  
  var delegate: ImagePreviewViewDelegate?
  var presenter: ImagePreviewPresenterProtocol?
  var message: MessageModel?
  
  init(message: MessageModel?, delegate: ImagePreviewViewDelegate?) {
    self.message = message
    self.delegate = delegate
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    style()
    layout()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupNavigationButton()
    titleLabe.text = message?.data.fileName
    presenter?.loadThumbnailImage(imagUrl: message?.data.url)
  }
  
  override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
    delegate?.didDismissImagePreview(message: message)
    super.dismiss(animated: flag, completion: completion)
  }
  
}

// MARK: - setup and layouting
extension ImagePreviewViewController {
  
  func setup() {
    self.view.backgroundColor = .black
    self.navigationItem.titleView = titleLabe
    
    if self.presenter == nil {
      presenter = ImagePreviewPresenter(
        repository: AppComponent.shared.getRepository(),
        thumbnailManager: AppComponent.shared.getImageManager(),
        delegate: self
      )
    }
  }
  
  func style() {
    zoomableImageView.translatesAutoresizingMaskIntoConstraints = false
    zoomableImageView.accessibilityIdentifier = "imageView"
    zoomableImageView.contentMode = .scaleAspectFit
  }
  
  func layout() {
    addToView(zoomableImageView)
    
    activatedWithConstraint([
      zoomableImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      zoomableImageView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor),
      zoomableImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      zoomableImageView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor)
    ])
    
  }
}

extension ImagePreviewViewController {
  
  func setupNavigationButton() {
    let barButtonBack = barBtnBack()
    barButtonBack.tintColor = .white
    self.navigationItem.leftBarButtonItem = barButtonBack
    
    let isDownloaded = self.message?.data.isDownloaded ?? false
    if !isDownloaded {
      let barButtonDownload =  UIBarButtonItem(
        title: "download",
        image: UIImage(systemName: "arrow.down")?.withTintColor(.white),
        target: self,
        action: #selector(downloadAction)
      )
      barButtonDownload.tintColor = .white
      self.navigationItem.rightBarButtonItem = barButtonDownload
    }
  }
  
  @objc func downloadAction() {
    if let message = self.message {
      presenter?.downloadImage(message: message)
    }
  }
  
}

// MARK: ~ handle ImagePreviewViewController
extension ImagePreviewViewController: ImagePreviewPresenter.ImagePreviewDelegate {
  
  func onLoadImageSuccess(imageData: Data?) {
    DispatchQueue.main.async {
      self.message?.data.previewImage?.data = imageData
      self.message?.data.previewImage?.state = .success
      
      if let imageData = imageData {
        self.zoomableImageView.imageView.image = UIImage(data: imageData)
      }
    }
  }
  
  func onDownloaded(message: MessageModel) {
    var message = message
    message.data.previewImage?.data = self.message?.data.previewImage?.data
    message.data.previewImage?.state = self.message?.data.previewImage?.state ?? .new
    self.message = message
    self.navigationItem.rightBarButtonItem?.isHidden = true
  }
  
  func onError(error: ChatError) {
    DispatchQueue.main.async {
      let alert = AlertUtils.alertDialog(
        title: "Error", message: error.localizedDescription, identifier: AlertUtils.identifierError
      )
      self.present(alert, animated: true, completion: nil)
    }
  }
  
}

protocol ImagePreviewViewDelegate {
  func didDismissImagePreview(message: MessageModel?)
}
