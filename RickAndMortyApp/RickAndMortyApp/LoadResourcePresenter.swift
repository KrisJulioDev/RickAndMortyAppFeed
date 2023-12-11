//
//  LoadResourcePresenter.swift
//  RickAndMortyApp
//
//  Created by Khristoffer Julio on 12/8/23.
//

import Foundation

public protocol ResourceView {
    associatedtype ResourceViewModel
    func display(_ viewModel: ResourceViewModel)
}

public final class LoadResourcePresenter<Resource, View: ResourceView> {
    public typealias Mapper = (Resource) throws -> View.ResourceViewModel
    private let resourceView: View
    private let mapper: Mapper
    
    init(resourceView: View, mapper: @escaping Mapper) {
        self.resourceView = resourceView
        self.mapper = mapper
    }
    
    func didStartLoading() {
        
    }
    
    func didFinishLoading(with resource: Resource) {
        do {
            resourceView.display(try mapper(resource))
        } catch {
            didFinishLoading(with: error)
        }
    }
    
    func didFinishLoading(with error: Error) {
        
    }
}

