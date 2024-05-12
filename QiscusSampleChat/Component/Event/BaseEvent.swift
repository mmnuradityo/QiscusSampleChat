//
//  BaseEvent.swift
//  QiscusSampleChat
//
//  Created by Admin on 09/05/24.
//

import Foundation

open class BaseEvent<T> {
  
  var dataItem: T?
  
  var observer: EventObserver?
  
  func register(observerEvent: EventObserver) {
    self.observer = observerEvent
  }
  
  func unregister() {
    self.observer = nil
    self.dataItem = nil
  }
  
}

protocol EventObserver {
  func onEventRoom(room: ChatRoomModel)
  func onEventMessage(message: MessageModel)
}
