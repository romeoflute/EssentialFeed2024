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
    
    public func binded(_ view: UIRefreshControl) -> UIRefreshControl {
		viewModel.onLoadingStateChange = { [weak view] isLoading in
			if isLoading {
				view?.beginRefreshing()
			} else {
                view?.endRefreshing()
			}
		}
		view.addTarget(self, action: #selector(refresh), for: .valueChanged)
		return view
	}
}
