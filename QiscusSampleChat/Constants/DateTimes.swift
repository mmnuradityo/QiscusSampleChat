//
//  DateTimes.swift
//  QiscusSampleChat
//
//  Created by Admin on 09/05/24.
//

import Foundation

class DateTimes {
  
  static let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    return formatter
  }()

  static let timeStampFormat: (Date?) -> String = { dateFormater in
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return dateFormater != nil ? formatter.string(from: dateFormater!) : "empty"
  }

  static let dateFormatter: (Date) -> String = { date in
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE, MM dd, yyyy"
    let dateStringer = formatter.string(from: date)
    return dateStringer
  }

}
