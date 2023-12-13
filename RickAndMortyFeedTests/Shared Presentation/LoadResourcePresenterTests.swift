//
//  LoadResourcePresenterTests.swift
//  RickAndMortyFeedTests
//
//  Created by Khristoffer Julio on 12/12/23.
//

import XCTest
import RickAndMortyFeed

final class LoadResourcePresenterTests: XCTestCase {
    func test_init_noMessageOnCreation() {
        let (view, _) = makeSUT()
        
        XCTAssertEqual(view.messages, [], "Expects no display invoke on load")
    }
    
    func test_startLoading_shouldReceiveDisplayLoading() {
        let (view, sut) = makeSUT()

        sut.didStartLoading()
        
        XCTAssertEqual(view.messages, [
            .display(error: .none),
            .display(isLoading: true)
        ], "Expects receive displayLoading on didStartLoading")
    }
    
    func test_finishLoading_stopsLoadingAndReceivesMappedValue() {
        let (view, sut) = makeSUT(mapper: { resource in
            resource + "resource"
        })

        sut.didFinishLoading(with: "viewmodel ")
        
        XCTAssertEqual(view.messages, [
            .display(isLoading: false),
            .display(resourceViewModel: "viewmodel resource")
        ])
    }
    
    func test_didFinishLoadingWithError_errorOnMapperDisplaysErrorAndFinishLoading() {
        let (view, sut) = makeSUT(mapper: { _ in throw anyError() })

        sut.didFinishLoading(with: "error on mapper")
        
        XCTAssertEqual(view.messages, [
            .display(error: SUT.loadError),
            .display(isLoading: false)
        ])
    }
    
    func test_didFinishLoadingWithError_successOnMapperFinishOnErrorAndFinishLoading() {
        let (view, sut) = makeSUT()
            
        sut.didFinishLoading(with: anyError())
        
        XCTAssertEqual(view.messages, [
            .display(error: SUT.loadError),
            .display(isLoading: false)
        ])
    }
    
    // MARK - Helpers
    private typealias SUT = LoadResourcePresenter<String, ViewSpy>
    
    private func makeSUT(
        mapper: @escaping SUT.Mapper = { _ in "Any"},
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (ViewSpy, SUT) {
        let view = ViewSpy()
        let sut = SUT(resourceView: view, loadingView: view, errorView: view, mapper: mapper)
        
        trackMemoryLeak(view, file: file, line: line)
        trackMemoryLeak(sut, file: file, line: line)
        return (view, sut)
    }
    
    private class ViewSpy: ResourceView, ResourceErrorView, ResourceLoadingView {
        typealias ResourceViewModel = String
         
        enum Message: Hashable {
            case display(resourceViewModel: String)
            case display(isLoading: Bool)
            case display(error: String?)
        }
        
        var messages = Set<Message>()
        
        func display(_ viewModel: ResourceErrorViewModel) {
            messages.insert(.display(error: viewModel.errorMessage))
        }
        
        func display(_ viewModel: ResourceLoadingViewModel) {
            messages.insert(.display(isLoading: viewModel.isLoading))
        }
        
        func display(_ viewModel: String) {
            messages.insert(.display(resourceViewModel: viewModel))
        }
    }
}
