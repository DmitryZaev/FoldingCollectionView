//
//  PushMessageModel.swift
//  FoldingCollectionView
//
//  Created by Dmitry Victorovich on 01.06.2022.
//

enum Apps: String, CaseIterable {
    case skype = "Skype"
    case pinterest = "Pinterest"
    case vk = "VK"
}

struct PushMessage {
    let appName: Apps
    let text: String
}
