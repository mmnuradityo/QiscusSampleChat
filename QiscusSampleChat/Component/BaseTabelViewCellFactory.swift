//
//  BaseTabelViewCellFactory.swift
//  QiscusSampleChat
//
//  Created by Admin on 30/04/24.
//

import UIKit

open class BaseTabelViewCellFactory<Model> {
  
  func registerCells(in tableView: UITableView) { }
  
  func create(fromTableView: UITableView, indexPath: IndexPath, data: Model?) -> UITableViewCell {
    return UITableViewCell()
  }
  
  func getIndentifier<T>(objectType: T.Type) -> String {
    return String(describing: type(of: objectType))
  }
  
}
