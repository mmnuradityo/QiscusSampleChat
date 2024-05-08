//
//  VideoTableViewCell.swift
//  QiscusSampleChat
//
//  Created by Admin on 26/04/24.
//

import UIKit

class VideoTableViewCell: ImageTableViewCell {
  
  let playButton = CarrierButton<MessageModel>(type: .custom)
  let durationLabel = TextLabel()
  let videoCoverView = UIView()
  let downloadButton = CarrierButton<MessageModel>(type: .custom)
  let downloadProgressView = CircularProgressView()
  var cellUploadIdentifier: String = ""
  
  override func configure(message: MessageModel) {
    super.configure(message: message)
    cellUploadIdentifier = message.id
    durationLabel.text = "00:00"
    
    playButton.isHidden = !message.data.isDownloaded
    downloadButton.isHidden = message.data.isDownloaded
    downloadProgressView.isHidden = true
    
    if !downloadButton.isHidden {
      downloadButton.data = message
      downloadButton.removeTarget(self, action: #selector(downloadButtonTaped), for: .touchUpInside)
      downloadButton.addTarget(self, action: #selector(downloadButtonTaped), for: .touchUpInside)
    } else {
      playButton.data = message
      playButton.removeTarget(self, action: #selector(playButtonTaped), for: .touchUpInside)
      playButton.addTarget(self, action: #selector(playButtonTaped), for: .touchUpInside)
    }
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
    
    downloadButton.translatesAutoresizingMaskIntoConstraints = false
    downloadButton.accessibilityIdentifier = "downloadButton"
    downloadButton.contentVerticalAlignment = .fill
    downloadButton.contentHorizontalAlignment = .fill
    downloadButton.imageView?.contentMode = .scaleAspectFit
    downloadButton.layer.cornerRadius = Images.playChatSize/2
    downloadButton.clipsToBounds = true
    downloadButton.tintColor = Colors.primaryColor
    downloadButton.setConfigureButton()
    downloadButton.setImage(
      UIImage(systemName: "arrow.down"), for: .normal
    )
    downloadButton.backgroundColor = Colors.bubleOtherColor
    
    downloadProgressView.translatesAutoresizingMaskIntoConstraints = false
    downloadProgressView.accessibilityIdentifier = "descriptionLabel"
    downloadProgressView.isHidden = true
    
    listOfContentView.append(videoCoverView)
    listOfContentView.append(playButton)
    listOfContentView.append(durationLabel)
    listOfContentView.append(downloadButton)
    listOfContentView.append(downloadProgressView)
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
      
      downloadButton.topAnchor.constraint(equalTo: playButton.topAnchor),
      downloadButton.bottomAnchor.constraint(equalTo: playButton.bottomAnchor),
      downloadButton.leadingAnchor.constraint(equalTo: playButton.leadingAnchor),
      downloadButton.trailingAnchor.constraint(equalTo: playButton.trailingAnchor),
      downloadButton.heightAnchor.constraint(equalToConstant: Images.playChatSize),
      downloadButton.widthAnchor.constraint(equalToConstant: Images.playChatSize),
      
      downloadProgressView.topAnchor.constraint(equalTo: downloadButton.topAnchor),
      downloadProgressView.bottomAnchor.constraint(equalTo: downloadButton.bottomAnchor),
      downloadProgressView.leadingAnchor.constraint(equalTo: downloadButton.leadingAnchor),
      downloadProgressView.trailingAnchor.constraint(equalTo: downloadButton.trailingAnchor),
      
      durationLabel.bottomAnchor.constraint(equalTo: videoCoverView.bottomAnchor, constant: -Dimens.smaller)
    ])
  }
  
}

// MARK: - Action
extension VideoTableViewCell: UploadDelegate {
  
  @objc func downloadButtonTaped(_ sender: UIButton) {
    if !downloadButton.isHidden {
      downloadButton.isHidden = true
      downloadProgressView.isHidden = false
      
      guard let message = (sender as! CarrierButton<MessageModel>).data else { return }
      
      delegate?.downloadFile(message: message, completion: { messageResult, progress, error in
        if messageResult != nil {
          self.configure(message: messageResult!)
        } else if progress != nil {
          self.downloadProgressView.progressAnimation(progress: progress!)
        } else if error != nil {
          self.downloadButton.isHidden = false
          self.downloadProgressView.isHidden = true
          self.playButton.isHidden = true
        }
      })
    }
  }
  
  @objc func playButtonTaped(_ sender: UIButton) {
    if !playButton.isHidden {
      guard let message = (sender as! CarrierButton<MessageModel>).data else { return }
      delegate?.playVideo(videoURL: message.data.url)
    }
  }
  
  func uploadIdentifier() -> String {
    return cellUploadIdentifier
  }
  
  func uploadFile(percent: Double) {
    downloadButton.isHidden = true
    if percent > 0 {
      playButton.isHidden = true
      downloadProgressView.isHidden = false
      downloadProgressView.progressAnimation(progress: Float(percent))
    } else {
      playButton.isHidden = false
      downloadProgressView.isHidden = true
    }
  }
  
}
