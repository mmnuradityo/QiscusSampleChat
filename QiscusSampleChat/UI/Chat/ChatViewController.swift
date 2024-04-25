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
  }
  
  func style() {
    chatToolbarView.delegate = self
    
    chatTableView.translatesAutoresizingMaskIntoConstraints = false
    chatTableView.backgroundColor = .systemOrange
    chatTableView.register(TextTableViewCell.self, forCellReuseIdentifier: TextTableViewCell.cellIdentifier)
    chatTableView.rowHeight = TextTableViewCell.rowHight
    chatTableView.dataSource = self
//    chatTableView.delegate = self
    
    chatFormView.delegate = self
    
    chatMenuView.isHidden = true
    chatMenuView.delegate = self
  }
  
  func layout() {
    addToView(chatToolbarView, chatTableView, chatFormView, chatMenuView)
    
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
    if let cell = tableView.dequeueReusableCell(
      withIdentifier: TextTableViewCell.cellIdentifier,
      for: indexPath
    ) as? TextTableViewCell {
      let chat = chatListDummy[indexPath.row]
      
      return cell
    }
    
    return UITableViewCell()
  }
  
}
