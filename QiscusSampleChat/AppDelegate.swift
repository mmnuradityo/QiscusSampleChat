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
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
    
    AppComponent.shared.getQiscusManager().setupEngine()
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.makeKeyAndVisible()
    window?.backgroundColor = .systemBackground
    window?.rootViewController = generateRootViewController()
    
    return true
  }
  
  private func generateRootViewController() -> UINavigationController {
    let viewController: UIViewController
    if AppComponent.shared.getDataStore().getUserLocalDateBase().getUser() != nil {
      viewController = ChatViewController()
    } else {
      viewController = LoginViewController()
    }
    return UINavigationController(rootViewController: viewController)
  }
  
}



