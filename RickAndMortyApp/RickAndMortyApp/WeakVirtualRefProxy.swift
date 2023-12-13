//
//  WeakVirtualRefProxy.swift
//  RickAndMortyApp
//
//  Created by Khristoffer Julio on 12/11/23.
//

import UIKit
import RickAndMortyFeed

final class WeakVirtualRefProxy<T: AnyObject> {
    private weak var object: T?
    
    init(_ object: T?) {
        self.object = object
    }
}

extension WeakVirtualRefProxy: ResourceView where T: ResourceView, T.ResourceViewModel ==  UIImage {
    typealias ResourceViewModel = UIImage
    
    func display(_ viewModel: UIImage) {
        object?.display(viewModel)
    }
}
 
extension WeakVirtualRefProxy: ResourceErrorView where T: ResourceErrorView {
    func display(_ viewModel: ResourceErrorViewModel) {
        object?.display(viewModel)
    }
}

extension WeakVirtualRefProxy: ResourceLoadingView where T: ResourceLoadingView {
    func display(_ viewModel: ResourceLoadingViewModel) {
        object?.display(viewModel)
    }
}
