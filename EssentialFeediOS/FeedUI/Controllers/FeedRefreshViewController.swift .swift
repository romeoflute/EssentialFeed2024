//
//  FeedRefreshViewController.swift .swift
//  EssentialFeediOS
//
//  Created by Romeo Flauta on 4/12/24.
//

import UIKit

public final class FeedRefreshViewController: NSObject, FeedLoadingView {
    public var view: UIRefreshControl = UIRefreshControl()
    private let presenter: FeedPresenter

    init(presenter: FeedPresenter) {
		self.presenter = presenter
        super.init()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
	}

	@objc func refresh() {
        presenter.loadFeed()
	}
    
    func display(isLoading: Bool) {
		if isLoading {
			view.beginRefreshing()
		} else {
			view.endRefreshing()
		}
	}
}
