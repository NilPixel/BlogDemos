//
//  ViewController.swift
//  DiffableDataSourceDemo
//
//  Created by Friday on 2020/9/22.
//

import UIKit

enum Section: CaseIterable {
    case main
}

struct Item: Hashable {
    let title: String

    init(title: String) {
        self.title = title
        self.identifier = UUID()
    }

    private let identifier: UUID
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.identifier)
    }
}

class ViewController: UIViewController {
    
    static let reuseIdentifier = "reuse-identifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()    // 配置UI
        configDataSource()      // 配置数据源
        updateUI()              // 数据源应用快照，更新UI
    }
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    var dataSource: UITableViewDiffableDataSource<Section, Item>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<Section, Item>! = nil
    lazy var mainItems: [Item] = {
        return [Item(title: "标题1"),
                Item(title: "标题2"),
                Item(title: "标题3")]
    }()
}

extension ViewController {
    
    func configDataSource() {
        self.dataSource = UITableViewDiffableDataSource<Section, Item>.init(tableView: self.tableView, cellProvider: {(tableView, indexPath, item) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: ViewController.reuseIdentifier, for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = item.title
            cell.contentConfiguration = content
            return cell
        })
        self.dataSource.defaultRowAnimation = .fade
    }
    
    func updateUI() {
        currentSnapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        currentSnapshot.appendSections([.main])
        currentSnapshot.appendItems(mainItems, toSection: .main)
        self.dataSource.apply(currentSnapshot, animatingDifferences: true)
    }
}

extension ViewController {
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ViewController.reuseIdentifier)
    }
}
