//
//  RoomListPresenter.swift
//  QiscusSampleChat
//
//  Created by Admin on 04/05/24.
//

import Foundation

protocol RoomListPresenterProtocol {
  func loadRooms(page: Int)
  func loadThumbnailImage(url: URL?, completion: @escaping (Data?, ImageModel.State) -> Void)
}

class RoomListPresenter: RoomListPresenterProtocol {
  
  let repository: RepositoryProtocol
  let delegate: RoomListDelegate
  
  init(repository: RepositoryProtocol, delegate: RoomListDelegate) {
    self.repository = repository
    self.delegate = delegate
  }
  
  func loadRooms(page: Int) {
    delegate.onloading(isLoading: true)
    
    repository.loadRooms(page: page, limit: 25) { chatRoomList in
      self.delegate.onloading(isLoading: false)
      self.delegate.onRooms(chatRoomList: chatRoomList)
    } onError: { error in
      self.delegate.onloading(isLoading: false)
      self.delegate.onError(error: error)
    }
  }
  
  func loadThumbnailImage(url: URL?, completion: @escaping (Data?, ImageModel.State) -> Void) {
    repository.loadThumbnailImage(url: url, completion: completion)
  }
  
  protocol RoomListDelegate {
    func onloading(isLoading: Bool)
    func onRooms(chatRoomList: ChatRoomListModel)
    func onError(error: ChatError)
  }
}
