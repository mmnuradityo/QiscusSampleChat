//
//  TableViewCellFactory.swift
//  QiscusSampleChat
//
//  Created by Admin on 25/04/24.
//

import UIKit

class TableViewCellFactory {
  
  func registerCells(in tableView: UITableView) {
    tableView.register(TextTableViewCell.self, forCellReuseIdentifier: getIndentifier(objectType: TextTableViewCell.self))
    tableView.register(ImageTableViewCell.self, forCellReuseIdentifier: getIndentifier(objectType: ImageTableViewCell.self))
    tableView.register(VideoTableViewCell.self, forCellReuseIdentifier: getIndentifier(objectType: VideoTableViewCell.self))
    tableView.register(FileTableViewCell.self, forCellReuseIdentifier: getIndentifier(objectType: FileTableViewCell.self))
  }
  
  func create(fromTableView: UITableView, indexPath: IndexPath, message: MessageModel) -> UITableViewCell {
    let identifier: String
    switch message.data.dataType {
    case .image:
      identifier = getIndentifier(objectType: ImageTableViewCell.self)
    case .video:
      identifier = getIndentifier(objectType: VideoTableViewCell.self)
    case .file:
      identifier = getIndentifier(objectType: FileTableViewCell.self)
    default:
      identifier = getIndentifier(objectType: TextTableViewCell.self)
    }
    
    guard let cell = fromTableView.dequeueReusableCell(
      withIdentifier: identifier, for: indexPath
    ) as? BaseTableViewCell else { return UITableViewCell() }
    
    cell.configure(message: message)
    
    return cell
  }

  private func getIndentifier<T>(objectType: T.Type) -> String {
    return String(describing: type(of: objectType))
  }
}
