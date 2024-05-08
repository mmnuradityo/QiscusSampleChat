//
//  CarrierButton.swift
//  QiscusSampleChat
//
//  Created by Admin on 06/05/24.
//

import UIKit

class CarrierButton<T>: UIButton {

   var data: T?

   override init(frame: CGRect) {
       super.init(frame: frame)
   }

   required init(coder aDecoder: NSCoder) {
       fatalError("This class does not support NSCoding")
   }
}
