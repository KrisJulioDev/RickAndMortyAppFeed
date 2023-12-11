//
//  LoadResourcePresentationAdapter.swift
//  RickAndMortyApp
//
//  Created by Khristoffer Julio on 12/8/23.
//

import Combine
import RickAndMortyFeed

public final class LoadResourcePresentationAdapter<Resource, View: ResourceView> {
    private let loader: () -> AnyPublisher<Resource, Error>
    private var cancellable: AnyCancellable?
    private var isLoading = false
    
    public var presenter: LoadResourcePresenter<Resource, View>?
    
    init(loader: @escaping () -> AnyPublisher<Resource, Error>) {
        self.loader = loader
    }
    
    func loadResource() {
        guard !isLoading else { return }
        isLoading = true
        presenter?.didStartLoading()
        
        cancellable = loader()
            .dispatchOnMainQueue()
            .handleEvents(receiveCancel: { [weak self] in
                self?.isLoading = false
            })
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self?.presenter?.didFinishLoading(with: error)
                }
            }, receiveValue: { [weak self] resource in
                self?.presenter?.didFinishLoading(with: resource)
            })
    }
}

extension LoadResourcePresentationAdapter: FeedImageCellControllerDelegate {
    public func didRequestImage() {
        loadResource()
    }
    
    public func didCancelRequestImage() {
        cancellable?.cancel()
        cancellable = nil
    }
}

