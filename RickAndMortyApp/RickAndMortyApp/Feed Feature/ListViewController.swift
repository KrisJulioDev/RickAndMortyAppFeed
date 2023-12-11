//
//  ListViewController.swift
//  RickAndMortyApp
//
//  Created by Khristoffer Julio on 12/6/23.
//

import Foundation
import UIKit


public final class ListViewController: UITableViewController {
    
    @IBOutlet private(set) weak var loadingView: LoadingView!
    
    private lazy var dataSource: UITableViewDiffableDataSource<Int, CellController> = {
        .init(tableView: tableView) { tableView, indexPath, controller in
            controller.dataSource.tableView(tableView, cellForRowAt: indexPath)
        }
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.dataSource = dataSource
        dataSource.defaultRowAnimation = .fade
    }
   
    func display(_ sections: [CellController]...) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CellController>()
        sections.enumerated().forEach { section, cellController in
            snapshot.appendSections([section])
            snapshot.appendItems(cellController, toSection: section)
        }
        dataSource.apply(snapshot)
    }
}
