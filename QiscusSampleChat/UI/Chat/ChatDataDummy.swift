//
//  ChatDataDummy.swift
//  QiscusSampleChat
//
//  Created by Admin on 25/04/24.
//

import Foundation
let sender =  MessageSenderModel(
  id: 1,
  name: "Qiscus",
  email: "qiscus@qiscus",
  avatarUrl: ""
)

let chatListDummy: [MessageModel] = [
  MessageModel(
    id: 1,
    time: "08.47",
    dateTime: "May 9, 2020",
    status: .read,
    chatFrom: .me,
    data: MessageDataModel(
      dataType: .text,
      fileName: "",
      url: "",
      caption: "chat satu"
    ),
    sender: sender,
    isFirst: true
  ),
  MessageModel(
    id: 2,
    time: "21.00",
    dateTime: "May 9, 2020",
    status: .sending,
    chatFrom: .other,
    data: MessageDataModel(
      dataType: .text,
      fileName: "",
      url: "",
      caption: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Pharetra pharetra massa massa ultricies mi quis hendrerit dolor magna. Justo eget magna fermentum iaculis eu non diam. Mus mauris vitae ultricies leo integer malesuada nunc. Nascetur ridiculus mus mauris vitae ultricies leo integer. Id neque aliquam vestibulum morbi blandit. Mi tempus imperdiet nulla malesuada. Mauris cursus mattis molestie a iaculis at. Metus vulputate eu scelerisque felis. In eu mi bibendum neque egestas. Consectetur libero id faucibus nisl tincidunt. Ut porttitor leo a diam sollicitudin tempor id eu. Amet est placerat in egestas erat imperdiet sed euismod nisi. Aliquam sem fringilla ut morbi tincidunt augue interdum velit euismod. Tincidunt eget nullam non nisi est sit amet facilisis magna. Feugiat vivamus at augue eget arcu dictum varius duis at."
    ),
    sender: sender,
    isFirst: true
  ),
  MessageModel(
    id: 3,
    time: "17.15",
    dateTime: "May 9, 2020",
    status: .failed,
    chatFrom: .me,
    data: MessageDataModel(
      dataType: .image,
      fileName: "",
      url: "",
      caption: ""
    ),
    sender: sender,
    isFirst: true
  ),
  MessageModel(
    id: 4,
    time: "01.00",
    dateTime: "May 9, 2020",
    status: .delivered,
    chatFrom: .other,
    data: MessageDataModel(
      dataType: .image,
      fileName: "",
      url: "",
      caption: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
    ),
    sender: sender,
    isFirst: true
  ),
  MessageModel(
    id: 5,
    time: "23.01",
    dateTime: "May 9, 2020",
    status: .delivered,
    chatFrom: .me,
    data: MessageDataModel(
      dataType: .video,
      fileName: "",
      url: "",
      caption: ""
    ),
    sender: sender
  ),
  MessageModel(
    id: 6,
    time: "14.30",
    dateTime: "May 9, 2020",
    status: .failed,
    chatFrom: .other,
    data: MessageDataModel(
      dataType: .video,
      fileName: "",
      url: "",
      caption:  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Pharetra pharetra massa massa ultricies mi quis hendrerit dolor magna. Justo eget magna fermentum iaculis eu non diam. Mus mauris vitae ultricies leo integer malesuada nunc. Nascetur ridiculus mus mauris vitae ultricies leo integer. Id neque aliquam vestibulum morbi blandit. Mi tempus imperdiet nulla malesuada. Mauris cursus mattis molestie a iaculis at. Metus vulputate eu scelerisque felis. In eu mi bibendum neque egestas. Consectetur libero id faucibus nisl tincidunt. Ut porttitor leo a diam sollicitudin tempor id eu. Amet est placerat in egestas erat imperdiet sed euismod nisi. Aliquam sem fringilla ut morbi tincidunt augue interdum velit euismod. Tincidunt eget nullam non nisi est sit amet facilisis magna. Feugiat vivamus at augue eget arcu dictum varius duis at."
    ),
    sender: sender,
    isFirst: false
  ),
  MessageModel(
    id: 7,
    time: "20.22",
    dateTime: "May 9, 2020",
    status: .sending,
    chatFrom: .me,
    data: MessageDataModel(
      dataType: .file,
      fileName: "file name.docx",
      url: "",
      caption: ""
    ),
    sender: sender,
    isFirst: false
  ),
  MessageModel(
    id: 7,
    time: "20.22",
    dateTime: "May 9, 2020",
    status: .read,
    chatFrom: .other,
    data: MessageDataModel(
      dataType: .file,
      fileName: "file name.docx",
      url: "",
      caption: ""
    ),
    sender: sender,
    isFirst: false
  )
]
