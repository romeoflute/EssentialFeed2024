//
//  FeedRefreshViewController.swift .swift
//  EssentialFeediOS
//
//  Created by Romeo Flauta on 4/12/24.
//

import UIKit
import EssentialFeed

public final class FeedRefreshViewController: NSObject {
    public var view: UIRefreshControl

	private let feedLoader: FeedLoader

	init(feedLoader: FeedLoader) {
		self.feedLoader = feedLoader
        self.view = UIRefreshControl()
        super.init()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
	}

	var onRefresh: (([FeedImage]) -> Void)?

	@objc func refresh() {
		view.beginRefreshing()
		feedLoader.load { [weak self] result in
			if let feed = try? result.get() {
				self?.onRefresh?(feed)
			}
			self?.view.endRefreshing()
		}
	}
}
