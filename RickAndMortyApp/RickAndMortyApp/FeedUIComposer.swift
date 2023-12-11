//
//  FeedUIComposer.swift
//  RickAndMortyApp
//
//  Created by Khristoffer Julio on 12/8/23.
//

import UIKit
import Combine
import RickAndMortyFeed

public struct Paginated<Item> {
    public typealias LoadMoreCompletion = (Result<Self, Error>) -> Void
    
    public let items: [Item]
    public let loadMore: ((@escaping LoadMoreCompletion) -> Void)?
    
    public init(items: [Item], loadMore: ((@escaping LoadMoreCompletion) -> Void)? = nil) {
        self.items = items
        self.loadMore = loadMore
    }
}

public extension Paginated {
    init(items: [Item], loadMorePublisher: (() -> AnyPublisher<Self, Error>)?) {
        self.init(items: items, loadMore: loadMorePublisher.map { publisher in
            return { completion in
                publisher().subscribe(
                    Subscribers.Sink(
                        receiveCompletion: { result in
                            if case let .failure(error) = result {
                                completion(.failure(error))
                            }
                        }, receiveValue: { value in
                            completion(.success(value))
                        }
                ))
            }
        })
    }
    
    var loadMorePublisher: (() -> AnyPublisher<Self, Error>)? {
        guard let loadMore = loadMore else { return nil }
        
        return {
            Deferred {
                Future(loadMore)
            }.eraseToAnyPublisher()
        }
    }
}

public final class FeedUIComposer {
    private init() {}
    
    public typealias FeedPresentationAdapter = LoadResourcePresentationAdapter<Paginated<CharacterItem>, FeedViewAdapter>
     
    public static func composeWith(
        feedLoader: @escaping () -> AnyPublisher<Paginated<CharacterItem>, Error>,
        imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher,
        selection: @escaping (CharacterItem) -> Void = { _ in }
    ) -> ListViewController {
        let presentationAdapter = FeedPresentationAdapter(loader: feedLoader)
        let feedController = makeFeedController()
        
        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: FeedViewAdapter(imageLoader: imageLoader, 
                                          controller: feedController,
                                          selection: selection),
            mapper: { $0 }
        )
        
        return feedController
    }
    
    static func makeFeedController() -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! ListViewController
        feedController.title = "Rick and Morty"
        return feedController
    }
}
