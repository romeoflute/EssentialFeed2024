//
//  FeedRefreshViewController.swift .swift
//  EssentialFeediOS
//
//  Created by Romeo Flauta on 4/12/24.
//

import UIKit
import EssentialFeed

protocol FeedRefreshViewControllerDelegate {
	func didRequestFeedRefresh()
}

public final class FeedRefreshViewController: NSObject, FeedLoadingView {
    @IBOutlet public var view: UIRefreshControl?
    var delegate: FeedRefreshViewControllerDelegate?

	@IBAction func refresh() {
		delegate?.didRequestFeedRefresh()
	}
    
    public func display(_ viewModel: FeedLoadingViewModel) {
		if viewModel.isLoading {
			view?.beginRefreshing()
		} else {
			view?.endRefreshing()
		}
	}
}
