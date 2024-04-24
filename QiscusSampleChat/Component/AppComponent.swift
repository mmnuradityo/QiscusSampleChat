//
//  AppComponent.swift
//  QisusSampleChat
//
//  Created by Admin on 23/04/24.
//

import QiscusCore

class AppComponent {
  
  static let shared: AppComponent = AppComponent()
  
  private var  dataStore: DataStoreProtocol!
  private var  qiscusManager: QiscusManagerProtocol!
  private var  repository: RepositoryProtocol!
  
  func getDataStore() -> DataStoreProtocol {
    if dataStore == nil {
      dataStore = DataStore(userLocalDateBase: UserLocalDateBase())
    }
    return dataStore
  }
  
  func getQiscusManager() -> QiscusManagerProtocol {
    if qiscusManager == nil {
      qiscusManager = QiscusManager()
    }
    return qiscusManager
  }
  
  func getRepository() -> RepositoryProtocol {
    if repository == nil {
      repository = Repository(dataStore: getDataStore(), qiscusManager: getQiscusManager())
    }
    return repository
  }
}
