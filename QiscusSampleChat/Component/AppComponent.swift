//
//  AppComponent.swift
//  QiscusSampleChat
//
//  Created by Admin on 23/04/24.
//

import QiscusCore

class AppComponent {
  
  static let shared: AppComponent = AppComponent()
  
  private var dataStore: DataStoreProtocol!
  private var qiscusManager: QiscusManagerProtocol!
  private var imageManager: ThumbnailManagerProtocol!
  private var repository: RepositoryProtocol!
  private var chatEventHandler: EventHandlerProtocol!
  private var notiicationfUtils: NotificationUtilsProtocol!
  
  func getDataStore() -> DataStoreProtocol {
    if dataStore == nil {
      dataStore = DataStore(userLocalDateBase: UserLocalDateBase())
    }
    return dataStore
  }
  
  func getImageManager() -> ThumbnailManagerProtocol {
    if imageManager == nil {
      imageManager = ThumbnailManager()
    }
    return imageManager
  }
  
  func getQiscusManager() -> QiscusManagerProtocol {
    if qiscusManager == nil {
      qiscusManager = QiscusManager()
    }
    return qiscusManager
  }
  
  func getRepository() -> RepositoryProtocol {
    if repository == nil {
      repository = Repository(
        dataStore: getDataStore(), imageManager: getImageManager(), qiscusManager: getQiscusManager()
      )
    }
    return repository
  }
  
  func getEventHandler() -> EventHandlerProtocol {
    if chatEventHandler == nil {
      chatEventHandler = EventHandler(repository: getRepository())
    }
    return chatEventHandler
  }
 
  func getNotificationUtils() -> NotificationUtilsProtocol {
    if notiicationfUtils == nil {
      notiicationfUtils = NotificationUtils()
    }
    return notiicationfUtils
  }
  
}
