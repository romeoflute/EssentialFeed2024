//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Romeo Flauta on 4/10/24.
//

import UIKit

protocol FeedViewControllerDelegate {
    func didRequestFeedRefresh()
}

public final class FeedViewController: UITableViewController, UITableViewDataSourcePrefetching, FeedLoadingView {
    var delegate: FeedViewControllerDelegate?
    private var dataIsLoaded: Bool = false {
        didSet {
            print("data is loaded: \(dataIsLoaded)")
        }
    }
    
    var tableModel = [FeedImageCellController]() {
		didSet { tableView.reloadData() }
	}
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }

    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        if !dataIsLoaded {
            refresh()
            dataIsLoaded = true
        }
    }
    
    @IBAction private func refresh() {
		delegate?.didRequestFeedRefresh()
	}
    
    func display(_ viewModel: FeedLoadingViewModel) {
		if viewModel.isLoading {
			refreshControl?.beginRefreshing()
		} else {
			refreshControl?.endRefreshing()
		}
	}
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tableModel.count
	}

	public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view()
	}
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelCellControllerLoad(forRowAt: indexPath)
	}
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
		indexPaths.forEach { indexPath in
            cellController(forRowAt: indexPath).preload()
		}
	}
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelCellControllerLoad)
	}
    
    private func cellController(forRowAt indexPath: IndexPath) -> FeedImageCellController {
        return tableModel[indexPath.row]
	}
    
    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
		cellController(forRowAt: indexPath).cancelLoad()
	}
}
