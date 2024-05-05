//
//  VideoTableViewCell.swift
//  QiscusSampleChat
//
//  Created by Admin on 26/04/24.
//

import UIKit

class VideoTableViewCell: ImageTableViewCell {
  let playButton = UIButton(type: .custom)
  let durationLabel = TextLabel()
  let videoCoverView = UIView()
  
  override func configure(message: MessageModel) {
    super.configure(message: message)
    durationLabel.text = "00:00"
  }
}

// MARK: - setup and layouting
extension VideoTableViewCell {
  
  override func setup() {
    super.setup()
    
    videoCoverView.translatesAutoresizingMaskIntoConstraints = false
    
    playButton.translatesAutoresizingMaskIntoConstraints = false
    playButton.accessibilityIdentifier = "playButton"
    playButton.setImage(UIImage(named: Images.chatPlay), for: .normal)
    playButton.contentVerticalAlignment = .fill
    playButton.contentHorizontalAlignment = .fill
    playButton.imageView?.contentMode = .scaleAspectFit
    playButton.layer.cornerRadius = Images.playChatSize/2
    playButton.clipsToBounds = true
    
    durationLabel.translatesAutoresizingMaskIntoConstraints = false
    durationLabel.accessibilityIdentifier = "durationLabel"
    durationLabel.setPadding(
      top: Dimens.paddingChatVerticalDuration, bottom: Dimens.paddingChatVerticalDuration,
      left: Dimens.smallest, right: Dimens.smallest
    )
    durationLabel.font = UIFont(name: Fonts.interRegular, size: Fonts.descriptionChatSize)
    durationLabel.textColor = .white
    durationLabel.backgroundColor = Colors.primaryColor
    durationLabel.layer.cornerRadius = Dimens.smallest
    durationLabel.clipsToBounds = true
    
    listOfContentView.append(videoCoverView)
    listOfContentView.append(playButton)
    listOfContentView.append(durationLabel)
  }
  
  override func configureComponent() {
    super.configureComponent()
    activatedWithConstraint([
      videoCoverView.topAnchor.constraint(equalTo: contentImageView.topAnchor),
      videoCoverView.bottomAnchor.constraint(equalTo: textChatLabel.isHidden ?  contentImageView.bottomAnchor : textChatLabel.topAnchor),
      
      playButton.centerXAnchor.constraint(equalTo: videoCoverView.centerXAnchor),
      playButton.centerYAnchor.constraint(equalTo: videoCoverView.centerYAnchor),
      playButton.heightAnchor.constraint(equalToConstant: Images.playChatSize),
      playButton.widthAnchor.constraint(equalToConstant: Images.playChatSize),
      
      durationLabel.bottomAnchor.constraint(equalTo: videoCoverView.bottomAnchor, constant: -Dimens.smaller)
    ])
  }
  
}

