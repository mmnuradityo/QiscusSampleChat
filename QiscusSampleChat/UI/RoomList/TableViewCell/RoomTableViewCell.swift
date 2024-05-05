//
//  RoomTableViewCell.swift
//  QiscusSampleChat
//
//  Created by Admin on 04/05/24.
//

import UIKit

class RoomTableViewCell: BaseTableViewCell {
  
  let avatarImageView = UIImageView()
  let roomNameLabel = UILabel()
  let lastMessageLabel = UILabel()
  let timeLabel = UILabel()
  let counterLabel = TextLabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
    layout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(room: ChatRoomModel) {
    roomNameLabel.text = room.name
    lastMessageLabel.text = room.lastMessage?.data.caption
    timeLabel.text = room.lastMessage?.time
    
    if room.unreadCount > 0 {
      counterLabel.isHidden = false
      counterLabel.text = String(room.unreadCount)
    } else {
      counterLabel.isHidden = true
      counterLabel.text = ""
    }
  }
  
}

// MARK: - setup and layouting
extension RoomTableViewCell {
  
  private func setup() {
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .clear
    
    avatarImageView.translatesAutoresizingMaskIntoConstraints = false
    avatarImageView.accessibilityIdentifier = "avatarImageView"
    avatarImageView.layer.cornerRadius = Images.avatarSize/2
    avatarImageView.clipsToBounds = true
    
    roomNameLabel.translatesAutoresizingMaskIntoConstraints = false
    roomNameLabel.accessibilityIdentifier = "roomNameLabel"
    roomNameLabel.font = UIFont(
      name: Fonts.interRegular, size: Fonts.roomListNameSize
    )
    roomNameLabel.textColor = Colors.textDefaultColor
    roomNameLabel.numberOfLines = 1
    roomNameLabel.lineBreakMode = .byTruncatingTail
    
    lastMessageLabel.translatesAutoresizingMaskIntoConstraints = false
    lastMessageLabel.accessibilityIdentifier = "lastMessageLabel"
    lastMessageLabel.font = UIFont(
      name: Fonts.interRegular, size: Fonts.defaultSize
    )
    lastMessageLabel.textColor = Colors.textDefaultColor
    lastMessageLabel.numberOfLines = 1
    lastMessageLabel.lineBreakMode = .byTruncatingTail
    
    timeLabel.translatesAutoresizingMaskIntoConstraints = false
    timeLabel.accessibilityIdentifier = "timeLabel"
    timeLabel.font = UIFont(
      name: Fonts.interRegular, size: Fonts.roomTimeSize
    )
    timeLabel.textColor = Colors.textDefaultColor
    timeLabel.textAlignment = .right
    timeLabel.numberOfLines = 1
    
    counterLabel.translatesAutoresizingMaskIntoConstraints = false
    counterLabel.accessibilityIdentifier = "counterLabel"
    counterLabel.font = UIFont(
      name: Fonts.interRegular, size: Fonts.defaultSize
    )
    counterLabel.textAlignment = .center
    counterLabel.textColor = .white
    counterLabel.backgroundColor = .red
    counterLabel.layer.cornerRadius = Dimens.roomListCounterRadius
    counterLabel.layer.masksToBounds = true
    counterLabel.setPadding(
      top: Dimens.roomListCounterPadding, bottom: Dimens.roomListCounterPadding,
      left: Dimens.roomListCounterPadding, right: Dimens.roomListCounterPadding
    )
  }
  
  private func layout() {
    addToView([
      avatarImageView, roomNameLabel, lastMessageLabel, timeLabel, counterLabel
    ])
    
    activatedWithConstraint([
      avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Dimens.smaller),
      avatarImageView.widthAnchor.constraint(equalToConstant: Images.avatarSize),
      avatarImageView.heightAnchor.constraint(equalToConstant: Images.avatarSize),
      
      roomNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -Dimens.paddingRoomList),
      roomNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: Dimens.smallest),
      roomNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: timeLabel.leadingAnchor, constant: -Dimens.smallest),
      
      timeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -Dimens.paddingRoomList),
      contentView.trailingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: Dimens.smaller),
      timeLabel.widthAnchor.constraint(equalToConstant: 30),
      
      lastMessageLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: Dimens.paddingRoomList),
      lastMessageLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: Dimens.smallest),
      lastMessageLabel.trailingAnchor.constraint(lessThanOrEqualTo: counterLabel.leadingAnchor, constant: -Dimens.smaller),
      
      counterLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: Dimens.paddingRoomList),
      contentView.trailingAnchor.constraint(equalTo: counterLabel.trailingAnchor, constant: Dimens.smaller),
      counterLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: Dimens.roomListCounterSize)
    ])
  }
  
}

