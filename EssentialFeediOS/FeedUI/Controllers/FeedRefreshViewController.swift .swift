//
//  FeedRefreshViewController.swift .swift
//  EssentialFeediOS
//
//  Created by Romeo Flauta on 4/12/24.
//

import UIKit

public final class FeedRefreshViewController: NSObject {
    public var view: UIRefreshControl
    private let viewModel: FeedViewModel

    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
        self.view = UIRefreshControl()
        super.init()
        self.view = binded(self.view)
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
	}

	@objc func refresh() {
        viewModel.loadFeed()
	}
    
    private func binded(_ view: UIRefreshControl) -> UIRefreshControl {
		viewModel.onChange = { [weak self] viewModel in
			if viewModel.isLoading {
				self?.view.beginRefreshing()
			} else {
				self?.view.endRefreshing()
			}
		}
		view.addTarget(self, action: #selector(refresh), for: .valueChanged)
		return view
	}
}
