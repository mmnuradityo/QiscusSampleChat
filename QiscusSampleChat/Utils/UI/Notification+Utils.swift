//
//  Notification+Utils.swift
//  QiscusSampleChat
//
//  Created by Admin on 05/05/24.
//

import UIKit

class NotificationUtils: NSObject {
  
  override init() {
    super.init()
    UNUserNotificationCenter.current().delegate = self
  }
  
  func requestNotif(onGranted: @escaping () -> Void, onDenied: @escaping (NotificationError) -> Void) {
    UNUserNotificationCenter.current()
      .requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
        if granted {
          onGranted()
        } else {
          onDenied(NotificationError.denied)
        }
      }
  }
  
  func notify(title: String, subtitle: String, message: String) {
    DispatchQueue.main.async {
      let content = UNMutableNotificationContent()
      content.title = title
      content.subtitle = subtitle
      content.body = message
      content.sound = .default
      
      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
      
      let request = UNNotificationRequest(identifier: "message", content: content, trigger: trigger)
      
      let center = UNUserNotificationCenter.current()
      center.add(request) { error in
        if error != nil {
          print("Error = \(error?.localizedDescription ?? "Failed to show notification")")
        } else {
          print("notif has been scheduled")
        }
      }
    }
  }
  
}

// MARK: ~ handle UNUserNotificationCenterDelegate
extension NotificationUtils: UNUserNotificationCenterDelegate {
  
  func userNotificationCenter(
      _ center: UNUserNotificationCenter,
      willPresent notification: UNNotification,
      withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
      completionHandler([.banner, .badge, .sound])
  }

  func userNotificationCenter(
      _ center: UNUserNotificationCenter,
      didReceive response: UNNotificationResponse,
      withCompletionHandler completionHandler: @escaping () -> Void
  ) {
      print("data from notif == \(response.notification.request.content.userInfo)")
      completionHandler()
  }
  
}

enum NotificationError: LocalizedError, Equatable {
  case denied
  case custom(message: String)
  
  var errorDescription: String? {
    switch self {
    case .custom(let message):
      return message
    case .denied:
      return "Notification request is denied"
    }
  }
}
