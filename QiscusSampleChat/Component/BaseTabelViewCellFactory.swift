//
//  BaseTabelViewCellFactory.swift
//  QiscusSampleChat
//
//  Created by Admin on 30/04/24.
//

import UIKit

open class BaseTabelViewCellFactory<Model> {
  
  var tableView: UITableView?
  
  func registerCells(in tableView: UITableView) {
    self.tableView = tableView
  }
  
  func create(fromTableView: UITableView, indexPath: IndexPath, data: Model?) -> UITableViewCell {
    return UITableViewCell()
  }
  
  func getIndentifier<T>(objectType: T.Type) -> String {
    return String(describing: type(of: objectType))
  }
  
  func insertOrUpdateTableViewCell(index: [Int]) {
    let posibleCellNumbers = (self.tableView?.numberOfRows(inSection: 0) ?? 0) - 1
    if posibleCellNumbers == -1 {
      self.tableView?.reloadData()
      return
    }
    
    var indexPath: IndexPath!
    var insertPath: [IndexPath] = []
    var updatePath: [IndexPath] = []
    
    index.forEach { index in
      indexPath = IndexPath(row: index, section: 0)
      if index <= posibleCellNumbers {
        updatePath.append(indexPath)
      } else {
        insertPath.append(indexPath)
      }
    }
    
    self.tableView?.beginUpdates()
    if !insertPath.isEmpty {
      self.tableView?.insertRows(at: insertPath, with: .none)
    }
    if !updatePath.isEmpty {
      self.tableView?.reloadRows(at: updatePath, with: .none)
    }
    self.tableView?.endUpdates()
  }
  
}

struct CellUpdater {
  static let INSERT = -1
  static let UPDATE = 0
  static let DELETE = 1
  
  let status: Int
  let id: String
  
  init(_ status: Int, id: String) {
    self.status = status
    self.id = id
  }
}
