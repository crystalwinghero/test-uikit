//
//  ViewController.swift
//  test-uikit
//
//  Created by Crystalwing Bakaboe on 6/16/23.
//

import UIKit

class ViewController: UIViewController {
  
  lazy var tableView: UITableView = {
    let tableView = UITableView(frame: self.view.bounds)
    tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
    tableView.dataSource = self
    tableView.delegate = self
    return tableView
  }()
  
  lazy var sections: [SectionModel] = {
    [
      .init(
        title: "TableView",
        rows: [
          .init(
            title: "TableView + Async Image",
            action: .init(block: { [weak self] in
              self?.showTableViewAsyncImage()
            })
          )
        ]
      )
    ]
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    setup()
  }
  
  private func setup() {
    navigationItem.title = "Home"
    view.addSubview(tableView)
  }


}

extension ViewController {
  func showTableViewAsyncImage() {
    let vc = TableViewController(nibName: nil, bundle: nil)
    self.navigationController?.pushViewController(vc, animated: true)
  }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
  private func rowModel(for indexPath: IndexPath) -> RowModel? {
    guard indexPath.section < sections.count,
          indexPath.row < sections[indexPath.section].rows.count else {
      return nil
    }
    return sections[indexPath.section].rows[indexPath.row]
  }
  func numberOfSections(in tableView: UITableView) -> Int {
    sections.count
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard section < sections.count else { return 0 }
    return sections[section].rows.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier, for: indexPath)
    guard let rowModel = rowModel(for: indexPath) else { return cell }
    var config = cell.defaultContentConfiguration()
    config.text = rowModel.title
    cell.contentConfiguration = config
    return cell
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    UITableView.automaticDimension
  }
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    guard section < sections.count else { return nil }
    return sections[section].title
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let rowModel = rowModel(for: indexPath) else { return }
    guard !rowModel.action.isCancelled else { return }
    rowModel.action.perform()
  }
  
}
