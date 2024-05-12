//
//  EventHandler.swift
//  QiscusSampleChat
//
//  Created by Admin on 01/05/24.
//

import QiscusCore

class EventHandler: EventHandlerProtocol {
  
  let repository: RepositoryProtocol
  let connectionEvent: QiscusConnectionDelegate
  let roomEvent: BaseEvent<String>
  let messageEvent: BaseEvent<String>
  
  init(
    repository: RepositoryProtocol,
    connectionEvent: QiscusConnectionDelegate = ConnectionEvent(),
    roomEvent: BaseEvent<String> = RoomEvent(),
    messageEvent: BaseEvent<String> = MessageEvent()
  ) {
    self.repository = repository
    self.connectionEvent = connectionEvent
    self.roomEvent = roomEvent
    self.messageEvent = messageEvent
  }
  
  func connectToQiscus() {
    repository.connectToQiscus(delegate: connectionEvent)
  }
  
  func registerObserverRooms(observer: EventObserver) {
    roomEvent.register(observerEvent: observer)
    repository.subscribeChatRooms(delegate: roomEvent as! QiscusCoreDelegate)
  }
  
  func registerObserverMessages(observer: EventObserver, roomId: String) {
    messageEvent.register(observerEvent: observer)
    
    messageEvent.dataItem = roomId
    roomEvent.dataItem = roomId
    
    repository.subscribeChatRoom(
      delegate: messageEvent as! QiscusCoreRoomDelegate, roomId: roomId
    )
  }
  
  func removeObserver() {
    roomEvent.unregister()
    repository.unSubcribeChatRooms()
  }
  
  func removeObserver(roomId: String) {
    roomEvent.dataItem = nil
    messageEvent.unregister()
    repository.unSubcribeChatRoom(roomId: roomId)
  }
  
}

protocol EventHandlerProtocol {
  func connectToQiscus()
  func registerObserverRooms(observer: EventObserver)
  func registerObserverMessages(observer: EventObserver, roomId: String)
  func removeObserver()
  func removeObserver(roomId: String)
}
