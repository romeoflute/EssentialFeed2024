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
        
        self.refreshControl?.beginRefreshing()
    }

	@objc private func load() {
        loader?.load { _ in }
    }
}

final class FeedViewControllerTests: XCTestCase {

    func test_init_doesNotLoadFeed() {
        let (_, loader) = makeSUT()

        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    func test_viewDidLoad_loadsFeed() {
        let (sut, loader) = makeSUT()
        
        // Lesson: calls viewdidload
		sut.loadViewIfNeeded()

		XCTAssertEqual(loader.loadCallCount, 1)
	}
    
    func test_pullToRefresh_loadsFeed() {
		let (sut, loader) = makeSUT()
		sut.loadViewIfNeeded()

		sut.refreshControl?.simulatePullToRefresh()
		XCTAssertEqual(loader.loadCallCount, 1)

		sut.refreshControl?.simulatePullToRefresh()
		XCTAssertEqual(loader.loadCallCount, 2)
	}
    
    func test_viewIsAppearing_showsLoadingIndicator() {
        let (sut, _) = makeSUT()
        
        // call viewdidload
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.refreshControl?.isRefreshing, false)

        // call viewisappearing
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        XCTAssertEqual(sut.refreshControl?.isRefreshing, true)

        sut.refreshControl?.endRefreshing()
        XCTAssertEqual(sut.refreshControl?.isRefreshing, false)
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
        private(set) var loadCallCount: Int = 0
        
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
			loadCallCount += 1
		}
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
