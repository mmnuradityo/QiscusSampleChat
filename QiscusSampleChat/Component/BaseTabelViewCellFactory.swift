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
  
  func insertOrUpdateTableViewCell(cellUpdaters: [CellUpdater]) {
    insertOrUpdateRows { posibleCellNumbers in
      var indexPath: IndexPath!
      var insertPath: [IndexPath] = []
      var updatePath: [IndexPath] = []
      
      cellUpdaters.forEach { index in
        indexPath = IndexPath(row: index.index, section: 0)
        if index.status == CellUpdater.UPDATE
            && index.index <= posibleCellNumbers {
          updatePath.append(indexPath)
        } else {
          insertPath.append(indexPath)
        }
      }
      return (insertPath, updatePath)
    }
  }
  
  func insertOrUpdateTableViewCell(index: [Int]) {
    insertOrUpdateRows { posibleCellNumbers in
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
      return (insertPath, updatePath)
    }
  }
  
  private func insertOrUpdateRows(completion: @escaping (Int) -> ([IndexPath], [IndexPath])) {
    let posibleCellNumbers = (self.tableView?.numberOfRows(inSection: 0) ?? 0) - 1
    if posibleCellNumbers == -1 {
      self.tableView?.reloadData()
      return
    }
    
    let resultPath = completion(posibleCellNumbers)
    
    self.tableView?.beginUpdates()
    if !resultPath.0.isEmpty {
      self.tableView?.insertRows(at: resultPath.0, with: .none)
    }
    if !resultPath.1.isEmpty {
      self.tableView?.reloadRows(at: resultPath.1, with: .none)
    }
    self.tableView?.endUpdates()
  }
  
}

struct CellUpdater {
  static let INSERT = -1
  static let UPDATE = 0
  static let DELETE = 1
  
  let status: Int
  let index: Int
  
  init(_ status: Int, index: Int) {
    self.status = status
    self.index = index
  }
}
