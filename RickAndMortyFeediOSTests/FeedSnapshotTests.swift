//
//  FeedSnapshotTests.swift
//  RickAndMortyFeediOSTests
//
//  Created by Khristoffer Julio on 12/19/23.
//

import XCTest
import RickAndMortyFeediOS
@testable import RickAndMortyFeed

final class FeedSnapshotTests: XCTestCase {
    func test_emptyFeed() {
        let sut = makeSUT()
        
        sut.display(emptyFeed())
        
        assert(snapshot: sut.snapshot(for: .iPhone12(style: .light)), named: "EMPTY_FEED_light")
        assert(snapshot: sut.snapshot(for: .iPhone12(style: .dark)), named: "EMPTY_FEED_dark")
    }
    
    func test_feed_withContent() {
        let sut = makeSUT()
        
        sut.display(stubs: feedWithContent())
        
        assert(snapshot: sut.snapshot(for: .iPhone12(style: .light)), named: "FEED_WITH_CONTENT_light")
        assert(snapshot: sut.snapshot(for: .iPhone12(style: .dark)), named: "FEED_WITH_CONTENT_dark")
        
        assert(snapshot: sut.snapshot(for: .iPhone12(style: .light, contentSize: .extraExtraExtraLarge)), named: "FEED_WITH_CONTENT_light_extraExtraExtraLarge")
        
        assert(snapshot: sut.snapshot(for: .iPhone12(style: .dark, contentSize: .extraExtraExtraLarge)), named: "FEED_WITH_CONTENT_dark_extraExtraExtraLarge")
    }
    
    func test_feed_withFailingImage() {
        let sut = makeSUT()
        
        sut.display(stubs: feedWithFailImageContent())
        
        assert(snapshot: sut.snapshot(for: .iPhone12(style: .light)), named: "FEED_WITH_FAIL_IMAGE_CONTENT_light")
        assert(snapshot: sut.snapshot(for: .iPhone12(style: .dark)), named: "FEED_WITH_FAIL_IMAGE_CONTENT_dark")
        
        assert(snapshot: sut.snapshot(for: .iPhone12(style: .light, contentSize: .extraExtraExtraLarge)), named: "FEED_WITH_FAIL_IMAGE_CONTENT_light_extraExtraExtraLarge")
        
        assert(snapshot: sut.snapshot(for: .iPhone12(style: .dark, contentSize: .extraExtraExtraLarge)), named: "FEED_WITH_FAIL_IMAGE_CONTENT_dark_extraExtraExtraLarge")
    }
    
    func test_feed_withLoadMoreIndicator() {
        let sut = makeSUT()
        
        sut.display(feedWithLoadMoreIndicator())
        
        assert(snapshot: sut.snapshot(for: .iPhone12(style: .dark)), named: "FEED_WITH_LOAD_MORE_INDICATOR_light")
        assert(snapshot: sut.snapshot(for: .iPhone12(style: .dark)), named: "FEED_WITH_LOAD_MORE_INDICATOR_dark")
    }
    
    func test_feed_withLoadMoreError() {
        let sut = makeSUT()
        
        sut.display(feedWithLoadMoreError())
        
        assert(snapshot: sut.snapshot(for: .iPhone12(style: .light)), named: "FEED_WITH_LOAD_MORE_ERROR_light")
        assert(snapshot: sut.snapshot(for: .iPhone12(style: .dark)), named: "FEED_WITH_LOAD_MORE_ERROR_dark")
        
        assert(snapshot: sut.snapshot(for: .iPhone12(style: .light, contentSize: .extraExtraExtraLarge)), named: "FEED_WITH_LOAD_MORE_ERROR_light_extraExtraExtraLarge")
        assert(snapshot: sut.snapshot(for: .iPhone12(style: .dark, contentSize: .extraExtraExtraLarge)), named: "FEED_WITH_LOAD_MORE_ERROR_dark_extraExtraExtraLarge")
    }
    
    // MARK: Helpers
    
    private func makeSUT() -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! ListViewController
        controller.loadViewIfNeeded()
        controller.tableView.showsHorizontalScrollIndicator = false
        controller.tableView.showsVerticalScrollIndicator = false
        return controller
    }
    
    private func emptyFeed() -> [CellController] { [] }
    
    private func feedWithContent() -> [ImageStub] {
        [
            ImageStub(name: "Rick", status: "Alive", type: "n/a", species: "Human", image: UIImage.make(withColor: .red), location: "Earth", origin: "Mars"),
            ImageStub(name: "Morty", status: "Half-alive", type: "n/a", species: "Zombie", image: UIImage.make(withColor: .gray), location: "Mars", origin: "Earth"),
        ]
    }
    
    private func feedWithFailImageContent() -> [ImageStub] {
        [
            ImageStub(name: "Rick", status: "Alive", type: "n/a", species: "Human", image: nil, location: "Earth", origin: "Mars"),
            ImageStub(name: "Morty", status: "Half-alive", type: "n/a", species: "Zombie", image: nil, location: "Mars", origin: "Earth"),
        ]
    }
    
    private func feedWithLoadMoreIndicator() -> [CellController] {
        let stub = feedWithContent().last!
        let cellController = FeedImageCellController(viewModel: stub.viewModel, delegate: stub, selection: {})
        stub.controller = cellController
        
        let loadMore = LoadMoreCellController(callBack: {})
        loadMore.display(.init(isLoading: true))
        
        return [
            CellController(id: UUID(), cellController),
            CellController(id: UUID(), loadMore)
        ]
    }
     
    private func feedWithLoadMoreError() -> [CellController] {
        let stub = feedWithContent().last!
        let cellController = FeedImageCellController(viewModel: stub.viewModel, delegate: stub, selection: {})
        stub.controller = cellController
        
        let loadMore = LoadMoreCellController(callBack: {})
        loadMore.display(.init(errorMessage: "Couldn't connect to the server"))
        
        return [
            CellController(id: UUID(), cellController),
            CellController(id: UUID(), loadMore)
        ]
    }
}

private extension ListViewController {
    func display(stubs: [ImageStub]) {
        let cells: [CellController] = stubs.map { stub in
            let controller = FeedImageCellController(viewModel: stub.viewModel, delegate: stub, selection: {})
            
            stub.controller = controller
            return CellController(id: UUID(), controller)
        }
        
        display(cells)
    }
}

private class ImageStub: FeedImageCellControllerDelegate {
    let viewModel: FeedImageViewModel
    let image: UIImage?
    weak var controller: FeedImageCellController?
    
    init(name: String, status: String, type: String, species: String, image: UIImage?, location: String, origin: String, controller: FeedImageCellController? = nil) {
        self.viewModel = FeedImageViewModel(name: name, status: status, type: type, species: species, location: location, origin: origin)
        self.image = image
    }
    
    func didRequestImage() {
        controller?.display(.init(isLoading: true))
        if let image {
            controller?.display(image)
            controller?.display(ResourceErrorViewModel(errorMessage: .none))
        } else {
            controller?
                .display(ResourceErrorViewModel(errorMessage: "any"))
        }
    }
    
    func didCancelRequestImage() { }
}
