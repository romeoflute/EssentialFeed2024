//
//  FeedRefreshViewController.swift .swift
//  EssentialFeediOS
//
//  Created by Romeo Flauta on 4/12/24.
//

import UIKit

public final class FeedRefreshViewController: NSObject, FeedLoadingView {
    public var view: UIRefreshControl = UIRefreshControl()
    private let loadFeed: () -> Void

    init(loadFeed: @escaping () -> Void) {
        self.loadFeed = loadFeed
        super.init()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
	}

	@objc func refresh() {
        loadFeed()
	}
    
    func display(_ viewModel: FeedLoadingViewModel) {
		if viewModel.isLoading {
			view.beginRefreshing()
		} else {
			view.endRefreshing()
		}
	}
}
