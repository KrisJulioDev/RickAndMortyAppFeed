//
//  FeedViewAdapter.swift
//  RickAndMortyApp
//
//  Created by Khristoffer Julio on 12/8/23.
//

import UIKit
import Combine
import RickAndMortyFeed
import RickAndMortyFeediOS

public final class FeedViewAdapter: ResourceView {
    
    typealias ImageDataPresentationAdapter = LoadResourcePresentationAdapter<Data, WeakVirtualRefProxy<FeedImageCellController>>
    
    private typealias LoadMorePresentationAdapter = LoadResourcePresentationAdapter<Paginated<CharacterItem>, FeedViewAdapter>
    
    private weak var controller: ListViewController?
    private let currentFeed: [CharacterItem: CellController]
    private let imageLoader: (URL) -> FeedImageDataLoader.Publisher
    private let selection: (CharacterItem) -> Void
    
    public init(
        currentFeed: [CharacterItem: CellController] = [:],
        imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher,
        controller: ListViewController,
        selection: @escaping (CharacterItem) -> Void
    ) {
        self.currentFeed = currentFeed
        self.imageLoader = imageLoader
        self.controller = controller
        self.selection = selection
    }
    
    public func display(_ viewModel: Paginated<CharacterItem>) {
        guard let controller else { return }
        
        var currentFeed = currentFeed
        
        let feed = viewModel.items.map { model in
            if let cellController = currentFeed[model] {
                return cellController
            }
            
            let adapter = ImageDataPresentationAdapter(loader: { [imageLoader] in
                imageLoader(model.image)
            })
            
            let view = FeedImageCellController(
                viewModel: FeedImagePresenter.map(model),
                delegate: adapter,
                selection: { [selection] in
                    selection(model)
                })
            
            adapter.presenter = LoadResourcePresenter(
                resourceView: WeakVirtualRefProxy(view),
                loadingView: WeakVirtualRefProxy(view),
                errorView: WeakVirtualRefProxy(view),
                mapper: UIImage.tryMake)
            
            let controller = CellController(id: model, view)
            currentFeed[model] = controller
            return controller
        }
        
        guard let loadMorePublisher = viewModel.loadMorePublisher else {
            controller.display(feed)
            return
        }
        
        let loadMoreAdapter = LoadMorePresentationAdapter(loader: loadMorePublisher)
        let loadMore = LoadMoreCellController(callBack: loadMoreAdapter.loadResource)
         
        loadMoreAdapter.presenter = LoadResourcePresenter(
            resourceView: FeedViewAdapter(currentFeed: currentFeed, imageLoader: imageLoader, controller: controller, selection: selection),
            loadingView: WeakVirtualRefProxy(loadMore),
            errorView: WeakVirtualRefProxy(loadMore),
            mapper: { $0 })
        
        let loadMoreSection = [CellController(id: UUID(), loadMore)]
        
        controller.display(feed, loadMoreSection)
    }
}

extension UIImage {
    struct InvalidImageData: Error { }
    
    static func tryMake(_ data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else {
            throw InvalidImageData()
        }
        
        return image
    }
}
