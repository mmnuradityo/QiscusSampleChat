//
//  TextTableViewCell.swift
//  QiscusSampleChat
//
//  Created by Admin on 25/04/24.
//

import UIKit

class TextTableViewCell: BaseTableViewCell {
  
  static let cellIdentifier = "TextTableViewCell"
  static let rowHight: CGFloat = 150
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
    layout()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
}

extension TextTableViewCell {
  
  private func setup() {
  }
  
  private func layout() {
    
  }
}
