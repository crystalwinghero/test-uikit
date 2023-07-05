//
//  SectionModel.swift
//  test-uikit
//
//  Created by Crystalwing Bakaboe on 6/17/23.
//

import Foundation

struct SectionModel {
  var title: String
  var rows: [RowModel]
}

struct RowModel {
  var title: String
  var action: DispatchWorkItem
}
