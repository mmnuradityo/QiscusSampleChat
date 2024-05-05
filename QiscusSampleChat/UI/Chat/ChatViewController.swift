//
//  ChatViewController.swift
//  QiscusSampleChat
//
//  Created by Admin on 24/04/24.
//

import UIKit

class ChatViewController: BaseViewController {
  
  static func instantiate(chatRoom: ChatRoomModel) -> UINavigationController {
    let viewController = ChatViewController()
    viewController.view.accessibilityIdentifier = "chatViewController"
    viewController.chatRoom = chatRoom
    
    let navigationController = UINavigationController(rootViewController: viewController)
    navigationController.modalPresentationStyle = .fullScreen
    navigationController.navigationBar.isHidden = true
    return navigationController
  }
  
  let chatToolbarView = ChatToolbarView()
  let chatTableView = UITableView()
  let chatFormView = ChatFormView()
  let chatMenuView = ChatMenuView()
  let floatingButton = UIButton(type: .custom)
  let progressView = LinearProgressView()
  var popupOptiosnMenuView: PopupOptionsMenuView?
  
  let tableViewCellFactory = ChatTableViewCellFactory()
  let filePicker = FilePickerUtils()
  
  var presenter: ChatPresenterProtocol?
  var chatRoom: ChatRoomModel?
  var isLoading: Bool = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    style()
    layout()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    presenter?.loadRoomWithMessage(roomId: chatRoom?.id ?? "")
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    removeDismissGesture()
    KeyboardUtils.removeObserver(self)
    AppComponent.shared.getChatEventHandler().removeObserver()
  }
  
}

// MARK: - setup and layouting
extension ChatViewController {
  
  func setup() {
    addDismissGesture()
    KeyboardUtils.setupKeyboradShowingOrHidding(
      self, willShowSelector: #selector(keyboardWillShow), willHideSelector: #selector(keyboardWillHide)
    )
    
    filePicker.delegate = self
    setupFooterView()
    
    if presenter == nil {
      AppComponent.shared.getChatEventHandler().connectToQiscus()
      presenter = ChatPresenter(
        repository: AppComponent.shared.getRepository(), delegate: self
      )
    }
    
    requestNotification()
  }
  
  func style() {
    chatToolbarView.accessibilityIdentifier = "chatToolbarView"
    chatToolbarView.delegate = self
    
    progressView.translatesAutoresizingMaskIntoConstraints = false
    progressView.accessibilityIdentifier = "progressView"
    progressView.progressTintColor = .systemYellow
    progressView.isHidden = true
    
    chatTableView.translatesAutoresizingMaskIntoConstraints = false
    chatTableView.accessibilityIdentifier = "chatTableView"
    chatTableView.backgroundColor = .clear
    chatTableView.rowHeight =  UIView.noIntrinsicMetric
    chatTableView.contentInset = UIEdgeInsets(
      top: Dimens.smaller, left: 0, bottom: Dimens.smaller, right: 0
    )
    chatTableView.transform = CGAffineTransform(scaleX: 1, y: -1)
    chatTableView.separatorStyle = .none
    chatTableView.separatorInset = .zero
    chatTableView.layoutMargins = .zero
    chatTableView.dataSource = self
    chatTableView.delegate = self
    
    tableViewCellFactory.registerCells(in: chatTableView)
    tableViewCellFactory.delegate = self
    
    chatFormView.accessibilityIdentifier = "chatFormView"
    chatFormView.delegate = self
    
    chatMenuView.accessibilityIdentifier = "chatMenuView"
    chatMenuView.isHidden = true
    chatMenuView.delegate = self
    
    floatingButton.translatesAutoresizingMaskIntoConstraints = false
    floatingButton.accessibilityIdentifier = "floatingButton"
    floatingButton.setBackgroundColor(
      color: Colors.strokeColor, forState: .normal
    )
    floatingButton.setImage(
      UIImage(systemName: "arrow.down"), for: .normal
    )
    floatingButton.clipsToBounds = true
    floatingButton.layer.masksToBounds = true
    floatingButton.tintColor = Colors.primaryColor
    floatingButton.layer.cornerRadius = Dimens.chatMenuHeight / 2
    floatingButton.isHidden = true
    floatingButton.addTarget(self, action: #selector(floatingButtonTaped), for: .touchUpInside)
  }
  
  func layout() {
    addToView(
      chatToolbarView, chatTableView, progressView, chatFormView, chatMenuView, floatingButton
    )
    
    activatedWithConstraint([
      chatToolbarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      chatToolbarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: chatToolbarView.trailingAnchor),
      chatToolbarView.heightAnchor.constraint(equalToConstant: Dimens.toolbarHeight),
      
      progressView.topAnchor.constraint(equalTo: chatToolbarView.bottomAnchor),
      progressView.heightAnchor.constraint(equalToConstant: Dimens.extraSmall),
      progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: progressView.safeAreaLayoutGuide.trailingAnchor),
      
      chatTableView.topAnchor.constraint(equalTo: chatToolbarView.bottomAnchor),
      chatTableView.bottomAnchor.constraint(equalTo: chatFormView.topAnchor),
      chatTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: chatTableView.safeAreaLayoutGuide.trailingAnchor),
      
      chatFormView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      chatFormView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: chatFormView.safeAreaLayoutGuide.trailingAnchor),
      chatFormView.heightAnchor.constraint(greaterThanOrEqualToConstant: Dimens.chatFormHeight),
      
      chatMenuView.topAnchor.constraint(equalTo: chatToolbarView.bottomAnchor),
      chatMenuView.bottomAnchor.constraint(equalTo: chatFormView.topAnchor),
      chatMenuView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: chatMenuView.safeAreaLayoutGuide.trailingAnchor),
      
      floatingButton.widthAnchor.constraint(equalToConstant: Dimens.chatMenuHeight),
      floatingButton.heightAnchor.constraint(equalToConstant: Dimens.chatMenuHeight),
      floatingButton.bottomAnchor.constraint(equalTo: chatFormView.topAnchor, constant: -Dimens.smaller),
      view.trailingAnchor.constraint(equalTo: floatingButton.trailingAnchor, constant: Dimens.smaller)
    ])

  }
}

// MARK: ~ handle ChatToolbarView action
extension ChatViewController: ChatToolbarViewDelegate, BaseViewController.TapOutsideDelegate {
  
  func backArrowButtonDidTapped() {
    backAction()
  }
  
  func menuOptionsDidTapped() {
    if popupOptiosnMenuView == nil {
      tapOutsideDelegate = self
      popupOptiosnMenuView = PopupOptionsMenuView()
      popupOptiosnMenuView?.accessibilityIdentifier = "popupOptiosnMenuView"
      popupOptiosnMenuView?.logoutButton.addTarget(self, action: #selector(logoutMenuTapped), for: .touchUpInside)
      popupOptiosnMenuView?.show(at: chatToolbarView.menuOptionsButton, in: view)
    } else {
      popupOptiosnMenuView?.hide(in: view)
      popupOptiosnMenuView = nil
    }
  }
  
  func handleTapOutside() {
    if chatToolbarView.menuOptionsButton.isSelected {
      chatToolbarView.setMenuOptionsButton()
      menuOptionsDidTapped()
    }
  }
  
}
// MARK: ~ handle ChatFormView action
extension ChatViewController: ChatFormViewDelegate {
  
  func menuButtonDidTapped() {
    showOrHideMenu()
  }
  
  func sendButtonDidTapped() {
    sendMessageText()
  }
  
}

// MARK: ~ handle ChatMennuView action
extension ChatViewController: ChatMenuViewDelegate {
  
  func cameraButtonDidTapped() {
    filePicker.imagePicker.sourceType = .camera
    present(filePicker.imagePicker, animated: true, completion: nil)
  }
  
  func galleryButtonDidTapped() {
    filePicker.imagePicker.sourceType = .photoLibrary
    present(filePicker.imagePicker, animated: true, completion: nil)
  }
  
  func fileButtonDidTapped() {
    present(filePicker.documentPicker, animated: true, completion: nil)
  }
  
  func outsideDidTapped() {
    showOrHideMenu()
  }
  
  private func showOrHideMenu() {
    chatMenuView.isHidden = !chatMenuView.isHidden
  }
  
}

// MARK: ~ handle show or hide Keyboard
extension ChatViewController {
  
  @objc func keyboardWillShow(_ sender: NSNotification) {
    guard let userInfo = sender.userInfo,
          let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
          let currentTextField = UIResponder.currentFirst() as? UITextView
    else { return }
    
    // check if the top of the keyboard is above the bottom of the currently focused textbox
    let keyboardTopY = keyboardFrame.cgRectValue.origin.y
    let convertedTextFieldFrame = view.convert(currentTextField.frame, from: currentTextField.superview)
    let textFieldBottomY = convertedTextFieldFrame.origin.y + convertedTextFieldFrame.size.height
    
    // if textField bottom is below keyboard bottom - bump the frame up
    if textFieldBottomY > keyboardTopY {
      let textboxY = textFieldBottomY + convertedTextFieldFrame.height + Dimens.smallest
      let newFrameY = (textboxY - keyboardTopY) * -1
      view.frame.origin.y = newFrameY
    }
  }
  
  @objc func keyboardWillHide(_ sender: NSNotification) {
    view.frame.origin.y = 0
  }
  
  @objc func logoutMenuTapped(_ sender: UIButton) {
    presenter?.logout()
  }
  
}

// MARK: ~ handle UITableViewDataSource
extension ChatViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return getTableData().count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return tableViewCellFactory.create(
      fromTableView: tableView, indexPath: indexPath, data: getTableData()[indexPath.row]
    )
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  private func getTableData() -> [MessageModel] {
    if self.chatRoom != nil {
      return self.chatRoom!.listMessages
    }
    return []
  }
  
}

//MARK: ~ handle UITableViewDelegate
extension ChatViewController: UITableViewDelegate {
  
  private func setupFooterView() {
    let footerView = ChatFooterTableView(frame: .zero)
    footerView.accessibilityIdentifier = "headerView"
    
    var size = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    size.width = UIScreen.main.bounds.width
    footerView.frame.size = size
    
    chatTableView.tableFooterView = footerView
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if !isLoading {
      if indexPath.row == (self.getTableData().count - 1) {
        progressView.startIndefinateProgress()
        
        presenter?.loadMoreMessages(
          roomId: chatRoom?.id ?? "",
          lastMessageId: chatRoom?.listMessages[indexPath.row].id ?? ""
        )
      }
    }
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let currentOffset = scrollView.contentOffset.y
    let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
    
    if maximumOffset > 0 && currentOffset <= 0 {
      if !floatingButton.isHidden { floatingButton.isHidden = true }
    } else if maximumOffset - currentOffset > 5 {
      if floatingButton.isHidden { floatingButton.isHidden = false }
    }
  }
  
}

// MARK: ~ handle ChatPresenterDelegate
extension ChatViewController: ChatPresenter.ChatDelete {
  
  func onLoading(isLoading: Bool) {
    self.isLoading = isLoading
  }
  
  func onRoomWithMessage(chatRoomModel: ChatRoomModel) {
    if self.chatRoom == nil {
      self.chatRoom = chatRoomModel
    } else {
      self.chatRoom!.appendBefore(chatRoomModel.listMessages)
    }
    
    if let presenter = self.presenter {
      AppComponent.shared.getChatEventHandler().register(
        observerEvent: presenter as! ChatEventObserver, roomId: chatRoomModel.id
      )
    }
    
    configureToolbar(chatRoomModel: chatRoomModel)
    chatTableView.reloadData()
  }
  
  func onMessages(messageModels: [MessageModel]) {
    if self.chatRoom != nil {
      self.chatRoom!.appendBefore(messageModels)
      progressView.stopIndefinateProgress()
      chatTableView.reloadData()
    }
  }
  
  func onSendMessage(messageModel: MessageModel) {
    if self.chatRoom != nil {
      self.chatRoom!.appendOrUpdate(messageModel)
      chatTableView.reloadData()
    }
  }
  
  func onError(error: ChatError) {
    showAlert(
      titile: "Error", description: error.localizedDescription, identifier: AlertUtils.identifierError
    )
  }
  
  func onProgressUploadFIle(percent: Double) {
    // TODO:
  }
  
  func onRoomEvent(chatRoomModel: ChatRoomModel) {
    if self.chatRoom == nil {
      self.chatRoom = chatRoomModel
    } else if self.chatRoom!.id == chatRoomModel.id {
      let listMessages = self.chatRoom?.listMessages
      self.chatRoom = chatRoomModel
      self.chatRoom?.listMessages = listMessages ?? []
    }
  }
  
  func onMessageEvent(messageModel: MessageModel) {
    if self.chatRoom != nil && self.chatRoom!.id == messageModel.roomId {
      self.chatRoom?.appendOrUpdate(messageModel)
      chatTableView.reloadData()
    }
  }
  
  func onLogout() {
    self.navigationController?.viewControllers.removeAll()
    self.present(LoginViewController.instantiate(), animated: true)
  }
}

// MARK: ~ handle TableViewCellFactory
extension ChatViewController: ChatTableViewCellFactory.FactoryDelete {
  
  func loadThumbnailAvatar(message: MessageModel, index: IndexPath, completion: @escaping (Data?, ImageModel.State) -> Void) {
    presenter?.loadThumbnailImage(url: message.sender.avatarImage.url) { dataImage, imageState in
      DispatchQueue.main.async {
        if self.chatRoom != nil
            && self.chatRoom!.listMessages.count > index.row
        {
          var message = message
          message.sender.avatarImage.data = dataImage
          message.sender.avatarImage.state = imageState
          
          self.chatRoom?.listMessages[index.row] = message
          
          completion(dataImage, imageState)
        }
      }
    }
  }
  
  func loadThumbnailImage(message: MessageModel, index: IndexPath, completion: @escaping (Data?, ImageModel.State) -> Void) {
    presenter?.loadThumbnailImage(url: message.data.previewImage?.url) { dataImage, imageState in
      DispatchQueue.main.async {
        if self.chatRoom != nil
            && self.chatRoom!.listMessages.count > index.row
        {
          var message = message
          message.data.previewImage = ImageModel(
            url: message.data.previewImage?.url, data: dataImage, state: imageState
          )
          
          self.chatRoom?.listMessages[index.row] = message
          
          completion(dataImage, imageState)
        }
      }
    }
  }
  
  func loadThumbnailVideo(message: MessageModel, index: IndexPath, completion: @escaping (Data?, ImageModel.State) -> Void) {
    presenter?.loadThumbnailVideo(url: message.data.previewImage?.url) { dataImage, imageState in
      DispatchQueue.main.async {
        if self.chatRoom != nil
            && self.chatRoom!.listMessages.count > index.row
        {
          var message = message
          message.data.previewImage = ImageModel(
            url: message.data.previewImage?.url, data: dataImage, state: imageState
          )
          
          self.chatRoom?.listMessages[index.row] = message
          
          completion(dataImage, imageState)
        }
      }
    }
  }
  
}

// MARK: ~ handle FilePickerDelegate
extension ChatViewController: FilePickerUtils.FilePickerDelegate {
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismissPricker()
  }
  
  func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    dismissPricker()
  }

  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
  ) {
    dismissPricker()
    
    filePicker.obtainDataFromImage(info: info) { imageUrl in
      self.sendMessageFile(from: imageUrl, caption: "")
    }
  }
  
  func documentPicker(
    _ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]
  ) {
    dismissPricker()
    
    filePicker.obtaiDataFromFile(urls: urls) { fileUrls in
      if fileUrls.count == 0 {
        self.showAlert(
          titile: "Error", description: "File result is empty!", identifier: AlertUtils.identifierError
        )
        return
      }
      
      let fileUrl = fileUrls[0]
      self.sendMessageFile(from: fileUrl, caption: "")
    } onError: { errorMessage in
      self.showAlert(
        titile: "Error", description: errorMessage, identifier: AlertUtils.identifierError
      )
    }
  }
  
  private func dismissPricker() {
    showOrHideMenu()
    dismiss(animated: true, completion: nil)
  }
  
}

// MARK: ~ handle UI Logic
extension ChatViewController {
  
  func configureToolbar(chatRoomModel: ChatRoomModel) {
    if !chatToolbarView.avatarImageView.isLoadImage(
      imageState: chatRoomModel.avatarImage?.state,
      dataImage: chatRoomModel.avatarImage?.data
    ) { return }
    
    chatToolbarView.userNameLabel.text = chatRoomModel.name
    chatToolbarView.userMemberLabel.text = chatRoomModel.participants
    
    presenter?.loadThumbnailImage(url: chatRoom?.avatarUrl) { imageData, imageState in
      self.chatRoom?.avatarImage = ImageModel(
        url: chatRoomModel.avatarUrl, data: imageData, state: imageState
      )
      
      DispatchQueue.main.async {
        _ = self.chatToolbarView.avatarImageView.isLoadImage(
          imageState: imageState, dataImage: imageData
        )
      }
    }
  }
  
  func sendMessageText() {
    if let message = chatFormView.formTextView.text {
      chatFormView.formTextView.text = ""
      
      let messageRequest = MessageRequest(
        roomId: chatRoom!.id, message: message, type: .text
      )
      
      presenter?.sendMessage(messageRequest: messageRequest)
    }
  }
  
  func sendMessageFile(from url: URL?, caption: String) {
    if let url = url {
      do {
        var messageRequest = MessageRequest(
          roomId: chatRoom!.id, message: caption, type: .file
        )
        messageRequest.fileRequest = MessageFileRequest(
          data: try Data(contentsOf: url),
          url: url,
          name: url.lastPathComponent,
          caption: caption
        )
        
        presenter?.sendMessageFile(messageRequest: messageRequest)
      } catch {
        self.showAlert(
          titile: "Error",
          description: "File can't be loaded with message \(error.localizedDescription)",
          identifier: AlertUtils.identifierError
        )
      }
    }
  }
  
  func showAlert(titile: String, description: String, identifier: String) {
      let alert = AlertUtils.alertDialog(
        title: titile, message: description, identifier: identifier
      )
      present(alert, animated: true, completion: nil)
  }
  
  @objc func floatingButtonTaped() {
    let firstIndexPath = IndexPath(row: 0, section: 0)
    chatTableView.scrollToRow(at: firstIndexPath, at: .top, animated: true)
  }
  
  func requestNotification() {
    AppComponent.shared.getNotificationUtils().requestNotif {
      // do nothing
    } onDenied: { error in
      DispatchQueue.main.sync {
        self.showAlert(
          titile: "Request Notification",
          description: error.localizedDescription,
          identifier: AlertUtils.identifierError
        )
      }
    }
  }
  
}
