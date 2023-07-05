//
//  ImageTaskManager.swift
//  test-uikit
//
//  Created by Crystalwing Bakaboe on 6/16/23.
//

import UIKit

struct ImageRequest {
  var id: AnyHashable
  var url: URL
  
  init(id: AnyHashable, url: URL) {
    self.id = id
    self.url = url
  }
  
  /// Only 1 download is allow for a single URL
  static func single(url: URL) -> ImageRequest {
    self.init(id: url.absoluteString, url: url)
  }
  
  /// Allow to download the same URL multiple time
  static func concurrent(url: URL) -> ImageRequest {
    self.init(id: UUID(), url: url)
  }
}

enum ImageUrlDownloadPolicy {
  case single
  case concurrent
}

protocol ImageTaskManagerProtocol {
  var imageUrlDownloadPolicy: ImageUrlDownloadPolicy { get }
  func download(url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) -> ImageRequest
  func cancel(request: ImageRequest)
}
extension ImageTaskManagerProtocol {
  var imageUrlDownloadPolicy: ImageUrlDownloadPolicy { .single }
  
  func imageRequest(from url: URL) -> ImageRequest {
    switch imageUrlDownloadPolicy {
    case .single:
      return .single(url: url)
    case .concurrent:
      return .concurrent(url: url)
    }
  }
}

class ImageTaskManager: ImageTaskManagerProtocol {
  var imageUrlDownloadPolicy: ImageUrlDownloadPolicy
  var session: URLSession
  private var tasks: [AnyHashable: URLSessionTask] = [:]
  
  deinit {
    cancelAll()
  }
  
  init(
    imageUrlDownloadPolicy: ImageUrlDownloadPolicy = .single,
    session: URLSession = .shared
  ) {
    self.imageUrlDownloadPolicy = imageUrlDownloadPolicy
    self.session = session
  }
  
  func download(url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) -> ImageRequest {
    let imageRequest = imageRequest(from: url)
    if imageUrlDownloadPolicy == .single {
      self.cancel(request: imageRequest) // cancel old download for single mode
    }
    let request = URLRequest(url: url)
    let task = session.dataTask(with: request) { [weak self] data, urlResponse, error in
      self?.cancel(request: imageRequest)
      if let data = data, let image = UIImage(data: data) {
        completion(.success(image))
      } else {
        let error = error ?? NSError(domain: url.absoluteString, code: NSURLErrorNetworkConnectionLost)
        completion(.failure(error))
      }
    }
    self.tasks[imageRequest.id] = task
    task.resume()
    return imageRequest
  }
  
  func cancel(request: ImageRequest) {
    guard let task = self.tasks.removeValue(forKey: request.id) else { return }
    task.cancel()
  }
  
  private func cancelAll() {
    for task in tasks.values {
      task.cancel()
    }
    tasks.removeAll()
  }
}
