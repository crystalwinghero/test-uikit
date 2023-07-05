//
//  UIKit+Utils.swift
//  test-uikit
//
//  Created by Crystalwing Bakaboe on 6/16/23.
//

import UIKit

func guaranteeMainThread(_ completion: @escaping () -> Void) {
  if Thread.isMainThread {
    completion()
  } else {
    DispatchQueue.main.async {
      completion()
    }
  }
}

extension UIView {
  static var reuseIdentifier: String { String(describing: self) }
}
