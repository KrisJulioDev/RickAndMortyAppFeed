//
//  FeedViewAdapter.swift
//  RickAndMortyApp
//
//  Created by Khristoffer Julio on 12/8/23.
//

import UIKit
import Combine
import RickAndMortyFeed

public final class FeedViewAdapter: ResourceView {
    
    typealias ImageDataPresentationAdapter = LoadResourcePresentationAdapter<Data, WeakVirtualRefProxy<FeedImageCellController>>
    
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
                mapper: UIImage.tryMake)
            
            let controller = CellController(id: model, view)
            currentFeed[model] = controller
            return controller
        }
        
        controller?.display(feed)
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
