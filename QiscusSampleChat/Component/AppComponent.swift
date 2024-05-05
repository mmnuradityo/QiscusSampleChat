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
  private var imageManager: ImageManagerProtocol!
  private var repository: RepositoryProtocol!
  private var chatEventHandler: ChatEventHandlerProtocol!
  private var notiicationfUtils: NotificationUtils!
  
  func getDataStore() -> DataStoreProtocol {
    if dataStore == nil {
      dataStore = DataStore(userLocalDateBase: UserLocalDateBase())
    }
    return dataStore
  }
  
  func getImageManager() -> ImageManagerProtocol {
    if imageManager == nil {
      imageManager = ImageManager()
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
  
  func getChatEventHandler() -> ChatEventHandlerProtocol {
    if chatEventHandler == nil {
      chatEventHandler = ChatEventHandler(repository: getRepository())
    }
    return chatEventHandler
  }
 
  func getNotificationUtils() -> NotificationUtils {
    if notiicationfUtils == nil {
      notiicationfUtils = NotificationUtils()
    }
    return notiicationfUtils
  }
  
}
