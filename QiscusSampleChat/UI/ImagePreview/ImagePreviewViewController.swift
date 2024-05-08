//
//  ImagePreviewViewController.swift
//  QiscusSampleChat
//
//  Created by Admin on 07/05/24.
//

import UIKit

class ImagePreviewViewController: BaseViewController {
  
  static let notificationMessage = Notification.Name(rawValue: "MessageImapePreview")
  static let dataKey = "data"
  
  static func instantiate(message: MessageModel, _ delegate: ImagePreviewViewDelegate) -> UINavigationController {
    let viewController = ImagePreviewViewController()
    viewController.view.accessibilityIdentifier = "imagePreviewViewController"
    viewController.delegate = delegate
    viewController.message = message
    
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
  let imageView = UIImageView()
  
  var delegate: ImagePreviewViewDelegate?
  var presenter: ImagePreviewPresenterProtocol?
  var message: MessageModel?
  
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
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.accessibilityIdentifier = "imageView"
    imageView.contentMode = .scaleAspectFit
  }
  
  func layout() {
    addToView(imageView)
    
    activatedWithConstraint([
      imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      imageView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor),
      imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor)
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
        self.imageView.image = UIImage(data: imageData)
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
    let alert = AlertUtils.alertDialog(
      title: "Error", message: error.localizedDescription, identifier: AlertUtils.identifierError
    )
    self.present(alert, animated: true, completion: nil)
  }
  
}

protocol ImagePreviewViewDelegate {
  func didDismissImagePreview(message: MessageModel?)
}
