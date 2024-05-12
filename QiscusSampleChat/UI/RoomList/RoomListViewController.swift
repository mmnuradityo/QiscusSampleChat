//
//  RoomListViewController.swift
//  QiscusSampleChat
//
//  Created by Admin on 04/05/24.
//

import UIKit

class RoomListViewController: BaseViewController {
  
  static func instantiate() -> UINavigationController {
    let viewController = RoomListViewController()
    viewController.view.accessibilityIdentifier = "roomListViewController"
    
    let navigationController = UINavigationController(rootViewController: viewController)
    navigationController.modalPresentationStyle = .fullScreen
    navigationController.navigationBar.isHidden = true
    return navigationController
  }
  
  let roomListToolbarView = RoomListToolbarView()
  let chatRoomTabelView = UITableView()
  let refreshControl = UIRefreshControl()
  
  let tableViewCellFactory = RoomTableViewCellFactory()
  
  var presenter: RoomListPresenterProtocol?
  var chatRoomList: ChatRoomListModel?
  var isLoading: Bool = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    style()
    layout()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let page = self.chatRoomList?.currentPage ?? 1
    presenter?.loadRooms(page: page)
  }

  deinit {
    AppComponent.shared.getEventHandler().removeObserver()
  }
  
}

// MARK: - setup and layouting
extension RoomListViewController {
  
  func setup() {
    if presenter == nil {
      presenter = RoomListPresenter(
        repository: AppComponent.shared.getRepository(), delegate: self
      )
      AppComponent.shared.getEventHandler().registerObserverRooms(
        observer: presenter as! EventObserver
      )
    }
    
    setupFooterView()
    setupRefreshControl()
    requestNotification()
  }
  
  func style() {
    roomListToolbarView.accessibilityIdentifier = "roomListToolbarView"
    
    chatRoomTabelView.translatesAutoresizingMaskIntoConstraints = false
    chatRoomTabelView.accessibilityIdentifier = "chatRoomTabelView"
    chatRoomTabelView.backgroundColor = .clear
    chatRoomTabelView.rowHeight = Dimens.roomListHeight
    chatRoomTabelView.separatorStyle = .singleLine
    chatRoomTabelView.separatorInset = UIEdgeInsets(
      top: 0, left: Dimens.smaller, bottom: 0, right: Dimens.smaller
    )
    chatRoomTabelView.dataSource = self
    chatRoomTabelView.delegate = self
    
    tableViewCellFactory.registerCells(in: chatRoomTabelView)
    tableViewCellFactory.delegate = self
  }
  
  func layout() {
    addToView(roomListToolbarView, chatRoomTabelView)
    
    activatedWithConstraint([
      roomListToolbarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      roomListToolbarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      roomListToolbarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      roomListToolbarView.heightAnchor.constraint(equalToConstant: Dimens.toolbarHeight),
      
      chatRoomTabelView.topAnchor.constraint(equalTo: roomListToolbarView.bottomAnchor),
      chatRoomTabelView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      chatRoomTabelView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      chatRoomTabelView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
    ])
  }
}

// MARK: ~ handle UITableViewDataSource
extension RoomListViewController: UITableViewDataSource {
  
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
  
  private func getTableData() -> [ChatRoomModel] {
    if self.chatRoomList != nil {
      return self.chatRoomList!.listRooms
    }
    return []
  }
  
}

// MARK: ~ handle UITableViewDelegate
extension RoomListViewController: UITableViewDelegate {
  
  private func setupFooterView() {
    let footerView = LoadingFooterTableView(frame: .zero)
    footerView.accessibilityIdentifier = "footer"
    
    var size = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    size.width = UIScreen.main.bounds.width
    footerView.frame.size = size
    
    chatRoomTabelView.tableFooterView = footerView
  }
  
  private func setupRefreshControl() {
    refreshControl.tintColor = Colors.primaryColor
    refreshControl.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
    chatRoomTabelView.refreshControl = refreshControl
  }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if getTableData().count > indexPath.row {
      let chatRoom = getTableData()[indexPath.row]
      self.present(ChatViewController.instantiate(chatRoom: chatRoom), animated: true)
    }
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if !isLoading {
      if indexPath.row == (self.getTableData().count - 1) {
        self.presenter?.loadRooms(page: chatRoomList!.currentPage + 1)
      }
    }
  }
  
}

// MARK: ~ handle RoomListDelegate
extension RoomListViewController: RoomListPresenter.RoomListDelegate {
  
  func onloading(isLoading: Bool) {
    self.isLoading = isLoading
  }
  
  func onRooms(chatRoomList: ChatRoomListModel) {
    self.chatRoomTabelView.refreshControl?.endRefreshing()
    
    if chatRoomList.listRooms.count == 0 {
      chatRoomTabelView.tableFooterView = nil
      chatRoomTabelView.reloadData()
      return
    }
    
    if self.chatRoomList == nil {
      self.chatRoomList = chatRoomList
      self.chatRoomTabelView.reloadData()
    } else if let indexs = self.chatRoomList?.configureWithNewData(chatRoomList: chatRoomList) {
      self.tableViewCellFactory.insertOrUpdateTableViewCell(index: indexs)
    }
  }
  
  func onRoom(room: ChatRoomModel) {
    if let indexs = self.chatRoomList?.appendOrUpdate(room: room) {
      self.tableViewCellFactory.insertOrUpdateTableViewCell(index: indexs)
    }
  }
  
  func onMessage(message: MessageModel) {
    if let indexs = self.chatRoomList?.updateLastMessage(message: message) {
      self.tableViewCellFactory.insertOrUpdateTableViewCell(index: indexs)
    }
  }
  
  func onError(error: ChatError) {
    let alert = AlertUtils.alertDialog(
      title: "Error", message: error.localizedDescription, identifier: AlertUtils.identifierError
    )
    self.present(alert, animated: true)
  }
  
}

// MARK: ~ hanlde
extension RoomListViewController: RoomTableViewCellFactory.FactoryDelete {
  
  func loadThumbnailAvatar(room: ChatRoomModel, index: IndexPath, completion: @escaping (Data?, ImageModel.State) -> Void) {
    presenter?.loadThumbnailImage(url: room.avatarImage?.url) { dataImage, imageState in
      DispatchQueue.main.async {
        if self.chatRoomList != nil {
          var room = room
          room.avatarImage?.data = dataImage
          room.avatarImage?.state = imageState
          
          self.chatRoomList?.listRooms[index.row] = room
          
          completion(dataImage, imageState)
        }
      }
    }
  }
  
}

// MARK: ~ hanlde Action
extension RoomListViewController {
  
  @objc func refreshContent() {
    chatRoomList = nil
    chatRoomTabelView.reloadData()
    presenter?.loadRooms(page: 1)
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
  
  func showAlert(titile: String, description: String, identifier: String) {
    let alert = AlertUtils.alertDialog(
      title: titile, message: description, identifier: identifier
    )
    present(alert, animated: true, completion: nil)
  }
  
}
