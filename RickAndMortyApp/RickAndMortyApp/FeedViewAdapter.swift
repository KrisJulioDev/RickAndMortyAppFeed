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
    
    private weak var controller: ListViewController?
    private let imageLoader: (URL) -> FeedImageDataLoader.Publisher
    private let selection: (CharacterItem) -> Void
    
    public init(imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher,
         controller: ListViewController,
         selection: @escaping (CharacterItem) -> Void
    ) {
        self.imageLoader = imageLoader
        self.controller = controller
        self.selection = selection
    }
    
    public func display(_ viewModel: Paginated<CharacterItem>) {
//        controller?.display(<#T##sections: [CellController]...##[CellController]#>)
    }
}
