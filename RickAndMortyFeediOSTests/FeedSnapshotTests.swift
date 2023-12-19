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
        
        sut.display(emptyFeed)
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "EMPTY_FEED_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "EMPTY_FEED_dark")
    }
    
    func test_feed_withContent() {
        let sut = makeSUT()
        
        sut.display(stubs: feedWithContent)
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "FEED_WITH_CONTENT_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "FEED_WITH_CONTENT_DARK")
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light, contentSize: .extraExtraExtraLarge)), named: "FEED_WITH_CONTENT_light_extraExtraExtraLarge")
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark, contentSize: .extraExtraExtraLarge)), named: "FEED_WITH_CONTENT_dark_extraExtraExtraLarge")
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
    
    private var emptyFeed: [CellController] { [] }
    
    private var feedWithContent: [ImageStub] {
        [
            ImageStub(name: "Rick", status: "Alive", type: "n/a", species: "Human", image: UIImage.make(withColor: .red)),
            ImageStub(name: "Morty", status: "Half-alive", type: "n/a", species: "Zombie", image: UIImage.make(withColor: .gray)),
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
    
    init(name: String, status: String, type: String, species: String, image: UIImage?, controller: FeedImageCellController? = nil) {
        self.viewModel = FeedImageViewModel(name: name, status: status, type: type, species: species)
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