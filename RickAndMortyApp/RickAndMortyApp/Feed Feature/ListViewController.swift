//
//  ListViewController.swift
//  RickAndMortyApp
//
//  Created by Khristoffer Julio on 12/6/23.
//

import UIKit
import RickAndMortyFeed

public final class ListViewController: UITableViewController, ResourceLoadingView, ResourceErrorView {

    private(set) public var errorView = ErrorView()
    public var onRefresh: (() -> Void)?
    
    private lazy var dataSource: UITableViewDiffableDataSource<Int, CellController> = {
        .init(tableView: tableView) { tableView, indexPath, controller in
            controller.dataSource.tableView(tableView, cellForRowAt: indexPath)
        }
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureErrorView()
        onRefresh?()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.sizeTableHeaderToFit()
    }
    
    private func configureErrorView() {
        let container = UIView()
        container.backgroundColor = .clear
        container.addSubview(errorView) 
        errorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            errorView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: errorView.trailingAnchor),
            errorView.topAnchor.constraint(equalTo: container.topAnchor),
            container.bottomAnchor.constraint(equalTo: errorView.bottomAnchor)
        ])
        
        tableView.tableHeaderView = container
        
        errorView.onHide = { [weak self] in
            guard let self else { return }
            self.tableView.beginUpdates()
            self.tableView.sizeTableHeaderToFit()
            self.tableView.endUpdates()
        }
    }
   
    func display(_ sections: [CellController]...) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CellController>()
        sections.enumerated().forEach { section, cellController in
            snapshot.appendSections([section])
            snapshot.appendItems(cellController, toSection: section)
        }
        
        if #available(iOS 15, *) {
            dataSource.apply(snapshot, animatingDifferences: false)
        } else {
            dataSource.apply(snapshot)
        }
    }
    
    public func display(_ viewModel: ResourceLoadingViewModel) {
        refreshControl?.update(isRefreshing: viewModel.isLoading)
    }
    
    public func display(_ viewModel: ResourceErrorViewModel) {
        errorView.message = viewModel.errorMessage
        tableView.sizeTableHeaderToFit()
    }
    
    @IBAction func refresh() {
        onRefresh?()
    }
}

extension UITableView {
    func sizeTableHeaderToFit() {
        guard let header = tableHeaderView else { return }
        
        let size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let needFrameUpdate = header.frame.height != size.height
        if needFrameUpdate {
            header.frame.size.height = size.height
            tableHeaderView = header
        }
    }
}
