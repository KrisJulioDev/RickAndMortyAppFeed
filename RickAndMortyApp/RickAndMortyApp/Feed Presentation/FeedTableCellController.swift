//
//  FeedTableCellController.swift
//  RickAndMortyApp
//
//  Created by Khristoffer Julio on 12/8/23.
//

import UIKit
import RickAndMortyFeed

public protocol FeedImageCellControllerDelegate {
    func didRequestImage()
    func didCancelRequestImage()
}

public struct FeedImageViewModel {
    let name: String
    let status: String
    let type: String
    let species: String
}

public final class FeedImageCellController: NSObject {
    public typealias Resource = UIImage
    
    private let viewModel: FeedImageViewModel
    private let delegate: FeedImageCellControllerDelegate
    private let selection: () -> Void
    private var cell: FeedTableViewCell?
    
    init(viewModel: FeedImageViewModel, delegate: FeedImageCellControllerDelegate, selection: @escaping () -> Void) {
        self.viewModel = viewModel
        self.delegate = delegate
        self.selection = selection
    }
}

extension FeedImageCellController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        cell?.name.text = viewModel.name
        cell?.status.text = viewModel.status
        cell?.species.text = viewModel.species
        cell?.type.text = viewModel.type
        cell?.contentImage.image = nil
        delegate.didRequestImage()
        
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        delegate.didRequestImage()
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        cancelLoad()
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelLoad()
    }
    
    private func cancelLoad() {
        releaseCell()
        delegate.didCancelRequestImage()
    }
    
    private func releaseCell() {
        cell = nil
    }
}

extension FeedImageCellController: ResourceView {
    public func display(_ viewModel: UIImage) {
        cell?.contentImage.setAnimated(viewModel)
        cell?.contentImage.sizeThatFits(viewModel.size)
    }
}

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
