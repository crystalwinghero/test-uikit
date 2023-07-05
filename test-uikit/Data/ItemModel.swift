//
//  ItemModel.swift
//  test-uikit
//
//  Created by Crystalwing Bakaboe on 6/16/23.
//

import Foundation

struct ItemModel: Codable, Identifiable {
  var id: Int
  var title: String
  var imageSize: Int = 128
  
  var imageUrl: URL {
    URL(string: "https://picsum.photos/id/\(id)/\(imageSize)")!
  }
  var imageName: String {
    "\(id)"
  }
}
