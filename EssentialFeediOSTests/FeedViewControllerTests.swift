//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by Romeo Flauta on 4/10/24.
//

import XCTest
import UIKit
import EssentialFeed

final class FeedViewController: UITableViewController {
    private var loader: FeedLoader?

	convenience init(loader: FeedLoader) {
		self.init()
		self.loader = loader
	}

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = FakeRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
	}
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        load()
    }

	@objc private func load() {
        self.refreshControl?.beginRefreshing()
        loader?.load { [weak self] _ in
            self?.refreshControl?.endRefreshing()
        }
    }
}

final class FeedViewControllerTests: XCTestCase {

    func test_init_doesNotLoadFeed() {
        let (_, loader) = makeSUT()

        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    func test_viewIsAppearing_loadsFeed() {
        let (sut, loader) = makeSUT()
        
        // Lesson: calls viewdidload
		sut.loadViewIfNeeded()
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()

		XCTAssertEqual(loader.loadCallCount, 1)
	}
    
    func test_userInitiatedFeedReload_reloadsFeed() {
		let (sut, loader) = makeSUT()
		sut.loadViewIfNeeded()

		sut.simulateUserInitiatedFeedReload()
		XCTAssertEqual(loader.loadCallCount, 1)

        sut.simulateUserInitiatedFeedReload()
		XCTAssertEqual(loader.loadCallCount, 2)
	}
    
    func test_viewIsAppearing_showsLoadingIndicator() {
        let (sut, _) = makeSUT()
        
        // call viewdidload
        sut.loadViewIfNeeded()
        XCTAssertFalse(sut.isShowingLoadingIndicator)

        // call viewisappearing
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        XCTAssertTrue(sut.isShowingLoadingIndicator)

        sut.refreshControl?.endRefreshing()
        XCTAssertFalse(sut.isShowingLoadingIndicator)
	}
    
    func test_viewIsAppearing_hidesLoadingIndicatorOnLoaderCompletion() {
		let (sut, loader) = makeSUT()

		sut.loadViewIfNeeded()
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        
		loader.completeFeedLoading()

        XCTAssertFalse(sut.isShowingLoadingIndicator)
	}
    
    func test_userInitiatedFeedReload_showsLoadingIndicator() {
		let (sut, _) = makeSUT()

		sut.simulateUserInitiatedFeedReload()

        XCTAssertTrue(sut.isShowingLoadingIndicator)
	}
    
    func test_userInitiatedFeedReload_hidesLoadingIndicatorOnLoaderCompletion() {
		let (sut, loader) = makeSUT()

        sut.simulateUserInitiatedFeedReload()
		loader.completeFeedLoading()

        XCTAssertFalse(sut.isShowingLoadingIndicator)
	}

    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedViewController, loader: LoaderSpy) {
		let loader = LoaderSpy()
		let sut = FeedViewController(loader: loader)
		trackForMemoryLeaks(loader, file: file, line: line)
		trackForMemoryLeaks(sut, file: file, line: line)
		return (sut, loader)
	}

    class LoaderSpy: FeedLoader {
        private var completions = [(FeedLoader.Result) -> Void]()

		var loadCallCount: Int {
			return completions.count
		}

        
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            completions.append(completion)
		}
        
        func completeFeedLoading() {
			completions[0](.success([]))
		}
    }
}

private extension FeedViewController {
	func simulateUserInitiatedFeedReload() {
		refreshControl?.simulatePullToRefresh()
	}
    
    var isShowingLoadingIndicator: Bool {
		return refreshControl?.isRefreshing == true
	}
}

private extension UIRefreshControl {
	func simulatePullToRefresh() {
		allTargets.forEach { target in
			actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
				(target as NSObject).perform(Selector($0))
			}
		}
	}
}

private extension FeedViewController {
    func createRefreshControlWithFakeForiOS17Support() -> UIRefreshControl {
        let fake = FakeRefreshControl()
        refreshControl?.allTargets.forEach { target in
            refreshControl?.actions(forTarget: target, forControlEvent: .valueChanged)?.forEach { action in
                fake.addTarget(target, action: Selector(action), for: .valueChanged)
            }
        }
        return fake
    }
}

private class FakeRefreshControl: UIRefreshControl {
    private var _isRefreshing = false
    
    override var isRefreshing: Bool { _isRefreshing }
    
    override func beginRefreshing() {
        _isRefreshing = true
    }
    
    override func endRefreshing() {
        _isRefreshing = false
    }
}
