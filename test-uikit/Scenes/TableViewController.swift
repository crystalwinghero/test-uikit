//
//  TableViewController.swift
//  test-uikit
//
//  Created by Crystalwing Bakaboe on 6/16/23.
//

import UIKit

class TableViewController: UITableViewController {
  
  var imageManager: ImageTaskManager = .init()
  
  private var requests: [IndexPath: ImageRequest] = [:]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem
  }
  
  private func setup() {
    navigationItem.title = "TableView + Async Image"
    tableView.separatorStyle = .none
    tableView.estimatedRowHeight = 110
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedSectionHeaderHeight = 44
    tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseIdentifier)
  }
  
  private func getItemModel(for indexPath: IndexPath) -> ItemModel {
    let id = (indexPath.section * 10) + indexPath.row + 1
    return ItemModel(id: id, title: "Item #\(id)")
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 10
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as? TableViewCell else {
      return UITableViewCell()
    }
    
    // Configure the cell...
    let item = getItemModel(for: indexPath)
    cell.updateData(with: item)
    cell.updateImage(nil) // reset image
    if let request = self.requests[indexPath] {
      imageManager.cancel(request: request)
    }
    self.requests[indexPath] =  imageManager.download(url: item.imageUrl) { [weak self] result in
      self?.requests.removeValue(forKey: indexPath)
      switch result {
      case .success(let image):
        guaranteeMainThread {
          cell.updateImage(image)
        }
        DispatchQueue.global().async {
          saveToDoc(image, name: "\(item.id)")
        }
      case .failure(let failure):
        print(#function, failure)
        return
      }
    }
    return cell
  }
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    UITableView.automaticDimension
  }
  
  override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if let request = self.requests[indexPath] {
      imageManager.cancel(request: request)
    }
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Section #\(section + 1)"
  }
  
}
