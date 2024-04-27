//
//  ChatViewController.swift
//  QiscusSampleChat
//
//  Created by Admin on 24/04/24.
//

import UIKit

class ChatViewController: BaseViewController {
  
  let chatToolbarView = ChatToolbarView()
  let chatTableView = UITableView()
  let chatFormView = ChatFormView()
  let chatMenuView = ChatMenuView()
  let floatingButton = UIButton(type: .custom)
  
  let tableViewCellFactory = TableViewCellFactory()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    style()
    layout()
  }
  
  deinit {
    KeyboardUtils.removeObserver(self)
  }
}

// MARK: - setup and layouting
extension ChatViewController {
  
  func setup() {
    self.navigationController?.navigationBar.isHidden = true
    KeyboardUtils.setupKeyboradShowingOrHidding(
      self, willShowSelector: #selector(keyboardWillShow), willHideSelector: #selector(keyboardWillHide)
    )
    
    setupHeaderView()
  }
  
  func style() {
    chatToolbarView.accessibilityIdentifier = "chatToolbarView"
    chatToolbarView.delegate = self
    
    chatTableView.translatesAutoresizingMaskIntoConstraints = false
    chatTableView.accessibilityIdentifier = "chatTableView"
    chatTableView.backgroundColor = .clear
    chatTableView.rowHeight =  UIView.noIntrinsicMetric
    chatTableView.contentInset = UIEdgeInsets(
      top: Dimens.smaller, left: 0, bottom: Dimens.smaller, right: 0
    )
    chatTableView.separatorStyle = .none
    chatTableView.separatorInset = .zero
    chatTableView.layoutMargins = .zero
    chatTableView.dataSource = self
    chatTableView.delegate = self
    tableViewCellFactory.registerCells(in: chatTableView)
    
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
  }
  
  func layout() {
    addToView(
      chatToolbarView, chatTableView, chatFormView, chatMenuView, floatingButton
    )
    
    NSLayoutConstraint.activate([
      chatToolbarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      chatToolbarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: chatToolbarView.trailingAnchor),
      chatToolbarView.heightAnchor.constraint(equalToConstant: Dimens.toolbarHeight),
      
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
extension ChatViewController: ChatToolbarViewDelegate {
  func backArrowButtonDidTapped() {
    backAction()
  }
  
  func menuOptionsDidTapped() {
    // TODO: ~
  }
}
// MARK: ~ handle ChatFormView action
extension ChatViewController: ChatFormViewDelegate {
  func menuButtonDidTapped() {
    showOrHideMenu()
  }
  
  func sendButtonDidTapped() {
    // TODO: ~
  }
}

// MARK: ~ handle ChatMennuView action
extension ChatViewController: ChatMenuViewDelegate {
  func cameraButtonDidTapped() {
    // TODO: ~
  }
  
  func galleryButtonDidTapped() {
    // TODO: ~
  }
  
  func fileButtonDidTapped() {
    // TODO: ~
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
}

// MARK: ~ handle UITableViewDataSource
extension ChatViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return chatListDummy.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return tableViewCellFactory.create(
      fromTableView: tableView, indexPath: indexPath, message: chatListDummy[indexPath.row]
    )
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
      return 1
  }
}

//MARK: ~ handle UITableViewDelegate
extension ChatViewController: UITableViewDelegate {
  
  private func setupHeaderView() {
    let headerView = HeaderTableView(frame: .zero)
    headerView.accessibilityIdentifier = "headerView"
    
    var size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    size.width = UIScreen.main.bounds.width
    headerView.frame.size = size
    
    chatTableView.tableHeaderView = headerView
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
}
