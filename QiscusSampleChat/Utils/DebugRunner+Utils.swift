//
//  DebugRunner.swift
//  QiscusSampleChat
//
//  Created by Admin on 30/04/24.
//

import Foundation

class DebugRunner {
  
  static func run(debug: @escaping () -> Void, release: @escaping () -> Void) {
    #if DEBUG
    debug()
    #else
    release()
    #endif
  }
  
  static func getArguments() -> [String] {
    return CommandLine.arguments
  }
  
  static func containtArgument(key: String) -> Bool {
    return getArguments().contains(key)
  }
  
  static func getEnvirontment(key: String) -> String? {
    return ProcessInfo.processInfo.environment[key]
  }
  
}

enum DebugArgumment: String {
  case skinLogin = "-skinLogin"
  case skinLoginSetAppId = "-skinLogin-setAppId"
}
