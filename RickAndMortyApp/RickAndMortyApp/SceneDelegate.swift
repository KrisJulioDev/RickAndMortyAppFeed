//
//  SceneDelegate.swift
//  RickAndMortyApp
//
//  Created by Khristoffer Julio on 12/6/23.
//

import UIKit
import CoreData
import Combine
import RickAndMortyFeed
 
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow? 
    
    private lazy var scheduler: AnyDispatchQueueScheduler = DispatchQueue(
            label: "com.rickandmorty.app",
            qos: .userInitiated,
            attributes: .concurrent
    ).eraseToAnyScheduler()
     
    private lazy var store: FeedStore & FeedImageDataStore = {
        do {
            return try CoreDataFeedStore(
                storeURL: NSPersistentContainer
                    .defaultDirectoryURL()
                    .appendingPathComponent("feed-store.sqlite")
            )
        } catch {
            assertionFailure()
            return NullStore()
        }
    }()
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }() 
    
    private lazy var navigationController: UINavigationController = UINavigationController(
        rootViewController: FeedUIComposer.composeWith(
            feedLoader: makeRemoteFeedLoaderWithLocalFallback,
            imageLoader: makeLocalImageLoaderWithRemoteFallback,
            selection: { _ in }))
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func configureWindow() {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    private func makeRemoteFeedLoaderWithLocalFallback() -> AnyPublisher<Paginated<CharacterItem>, Error> {
        
        return makeRemoteFeedLoader()
            .map(makeFirstPage)
            .eraseToAnyPublisher()
    }
    
    private func makeFirstPage(_ result: CharacterFeedResult) -> Paginated<CharacterItem> {
        makePage(result.results, info: result.info)
    }
    
    private func makePage(_ items: [CharacterItem], info: Info) -> Paginated<CharacterItem> {
        Paginated(items: items, loadMorePublisher:
            self.makeRemoteLoadMoreLoader(items, info: info)
        )
    }
    
    private func makeRemoteFeedLoader() -> AnyPublisher<CharacterFeedResult, Error> {
        let url = FeedEndpoint.get(nil).url
        return httpClient
            .getPublisher(url: url)
            .tryMap(CharacterFeedMapper.map)
            .eraseToAnyPublisher()
    }
    
    private func makeLocalImageLoaderWithRemoteFallback(with url: URL) -> FeedImageDataLoader.Publisher {
        
        let localImageLoader = LocalFeedImageDataLoader(store: store)
        return localImageLoader.loadImageDataPublisher(from: url)
            .fallback { [httpClient, scheduler] in
                httpClient.getPublisher(url: url)
                    .tryMap(CharacterImageMapper.map)
                    .caching(to: localImageLoader, using: url)
                    .subscribe(on: scheduler)
                    .eraseToAnyPublisher()
            }
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }
    
    private func makeRemoteLoadMoreLoader(_ items: [CharacterItem], info: Info)
    -> (() -> AnyPublisher<Paginated<CharacterItem>, Error>)? {
        guard let next = info.next, let url = URL(string: next) else { return nil }
        
        let endpoint = FeedEndpoint.get(NextPage(url: url)).url
        
        return { [httpClient] in
            httpClient
                .getPublisher(url: endpoint)
                .tryMap(CharacterFeedMapper.map)
                .map { newItems in
                    let allItems = items + newItems.results
                    return Paginated(items: allItems, loadMorePublisher: self.makeRemoteLoadMoreLoader(allItems, info: newItems.info))
                }
                .eraseToAnyPublisher()
        }
    }
}
