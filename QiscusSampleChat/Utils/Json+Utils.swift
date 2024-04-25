//
//  Json+Utils.swift
//  QiscusSampleChat
//
//  Created by Admin on 23/04/24.
//

import Foundation

protocol JsonUtilsProtocol {
  static func toJsonString<T>(target: T) -> String where T: Codable
  
  static func toModel<T>(_ type: T.Type, from data: Data) -> T? where T: Decodable
}

class JsonUtils: JsonUtilsProtocol {
  static func toJsonString<T>(target: T) -> String where T: Codable {
    var result: String!
    
    do {
      let jsonEncoder = JSONEncoder()
      let jsonData = try jsonEncoder.encode(target)
      result = String(data: jsonData, encoding: String.Encoding.utf8)
    } catch {
      result = ""
    }
    
    return result ?? ""
  }
  
  static func toModel<T>(_ type: T.Type, from data: Data) -> T? where T: Decodable {
    do {
      let jsonDecoder = JSONDecoder()
      let result = try jsonDecoder.decode(type, from: data)
      return result
    } catch {
      return nil
    }
  }
}
