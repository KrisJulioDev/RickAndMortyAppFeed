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
    
    public init(name: String, status: String, type: String, species: String) {
        self.name = name
        self.status = status
        self.type = type
        self.species = species
    }
}

public final class FeedImageCellController: NSObject {
    public typealias Resource = UIImage
    
    private let viewModel: FeedImageViewModel
    private let delegate: FeedImageCellControllerDelegate
    private let selection: () -> Void
    private var cell: FeedTableViewCell?
    
    public init(viewModel: FeedImageViewModel, delegate: FeedImageCellControllerDelegate, selection: @escaping () -> Void) {
        self.viewModel = viewModel
        self.delegate = delegate
        self.selection = selection
    }
}

extension FeedImageCellController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        cell?.name.text = viewModel.name
        cell?.species.text = viewModel.species
        cell?.contentContainer.isShimmering = true
        cell?.reloadButton.isHidden = true 
        cell?.contentImage.image = nil
        cell?.reload = delegate.didRequestImage
        delegate.didRequestImage()
        
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection : Int) -> Int {
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

extension FeedImageCellController: ResourceView, ResourceLoadingView, ResourceErrorView {
    public typealias ResourceViewModel = UIImage
    
    public func display(_ viewModel: UIImage) {
        cell?.contentImage.setAnimated(viewModel) 
    }
    
    public func display(_ viewModel: ResourceLoadingViewModel) {
        cell?.contentContainer.isShimmering = viewModel.isLoading
    }
    
    public func display(_ viewModel: ResourceErrorViewModel) {
        cell?.reloadButton.isHidden = viewModel.errorMessage == nil
    }
}

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
