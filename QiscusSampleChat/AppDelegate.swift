//
//  AppDelegate.swift
//  QiscusSampleChat
//
//  Created by Admin on 21/04/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?
  ) -> Bool {
    setupEngine()
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.makeKeyAndVisible()
    window?.backgroundColor = .systemBackground
    configureRootViewController()
    
    return true
  }
  
}

// MARK: ~ handle AppLogic
extension AppDelegate {
  
  private func setupEngine() {
    let enableLogDebug = false
    DebugRunner.run {
      let appIdToSet = AppConfiguration.APP_ID ?? ""
      let appId: String
      
      let argument = DebugRunner.getArguments()
      if argument.contains(DebugArgumment.skinLogin.rawValue) {
        appId = argument.contains(DebugArgumment.skinLoginSetAppId.rawValue) ? appIdToSet : ""
      } else {
        appId = appIdToSet
      }
      
      AppComponent.shared.getQiscusManager().setupEngine(
        appID: appId, enableLogDebug: enableLogDebug
      )
      AppComponent.shared.getEventHandler().connectToQiscus()
    } release: {
      AppComponent.shared.getQiscusManager().setupEngine(
        appID: AppConfiguration.APP_ID ?? "", enableLogDebug: enableLogDebug
      )
      AppComponent.shared.getEventHandler().connectToQiscus()
    }
  }
  
  private func configureRootViewController() {
    DebugRunner.run {
      let isLogin: Bool
      if !DebugRunner.containtArgument(key: DebugArgumment.skinLogin.rawValue) {
        isLogin = AppComponent.shared.getDataStore().getUserLocalDateBase().getUser() != nil
      } else {
        isLogin = false
      }
      self.window?.rootViewController = self.generateRootViewController(isLogin: isLogin)
    } release: {
      self.window?.rootViewController = self.generateRootViewController(
        isLogin: AppComponent.shared.getDataStore().getUserLocalDateBase().getUser() != nil
      )
    }
  }
  
  private func generateRootViewController(isLogin: Bool) -> UINavigationController {
    if isLogin {
      return RoomListViewController.instantiate()
    }
    return LoginViewController.instantiate()
  }
  
}

