//
//  RoomTableViewCellFactory.swift
//  QiscusSampleChat
//
//  Created by Admin on 04/05/24.
//

import UIKit

class RoomTableViewCellFactory: BaseTabelViewCellFactory<ChatRoomModel> {
  
  var delegate: FactoryDelete?
  
  override func registerCells(in tableView: UITableView) {
    tableView.register(RoomTableViewCell.self, forCellReuseIdentifier: getIndentifier(objectType: RoomTableViewCell.self))
  }
  
  override func create(fromTableView: UITableView, indexPath: IndexPath, data: ChatRoomModel?) -> UITableViewCell {
    guard let room = data else { return UITableViewCell() }
    
    let cell = fromTableView.dequeueReusableCell(
      withIdentifier: getIndentifier(objectType: RoomTableViewCell.self), for: indexPath
    ) as! RoomTableViewCell
    
    cell.configure(room: room)
    configureAvatar(cell, room: room, index: indexPath)
    
    return cell
  }
  
  protocol FactoryDelete {
    func loadThumbnailAvatar(
      room: ChatRoomModel, index: IndexPath, completion: @escaping (Data?, ImageModel.State) -> Void
    )
  }
}

// MARK: ~ Helper
extension RoomTableViewCellFactory {
  
  private func configureAvatar(_ cell: RoomTableViewCell, room: ChatRoomModel, index: IndexPath) {
    if !cell.avatarImageView.isLoadImage(
      imageState: room.avatarImage?.state,
      dataImage: room.avatarImage?.data
    ) { return }
    
    delegate?.loadThumbnailAvatar(room: room, index: index) { dataImage, imageState in
      _ = cell.avatarImageView.isLoadImage(imageState: imageState, dataImage: dataImage)
    }
  }
  
}
