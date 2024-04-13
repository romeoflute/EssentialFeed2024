//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Romeo Flauta on 4/10/24.
//

import UIKit
import EssentialFeed

public final class FeedViewController: UITableViewController, UITableViewDataSourcePrefetching {
    public var refreshController: FeedRefreshViewController?
    private var imageLoader: FeedImageDataLoader?
    private var dataIsLoaded: Bool = false {
        didSet {
            print("data is loaded: \(dataIsLoaded)")
        }
    }
    
    private var tableModel = [FeedImage]() {
		didSet { tableView.reloadData() }
	}
    private var cellControllers = [IndexPath: FeedImageCellController]()

    public convenience init(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) {
        self.init()
        self.refreshController = FeedRefreshViewController(feedLoader: feedLoader)
		self.imageLoader = imageLoader
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = refreshController?.view
		refreshController?.onRefresh = { [weak self] feed in
			self?.tableModel = feed
		}
		tableView.prefetchDataSource = self
    }

    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        if !dataIsLoaded {
            refreshController?.refresh()
            dataIsLoaded = true
        }
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tableModel.count
	}

	public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view()
	}
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        removeCellController(forRowAt: indexPath)
	}
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
		indexPaths.forEach { indexPath in
            cellController(forRowAt: indexPath).preload()
		}
	}
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(removeCellController)
	}
    
    private func cellController(forRowAt indexPath: IndexPath) -> FeedImageCellController {
		let cellModel = tableModel[indexPath.row]
		let cellController = FeedImageCellController(model: cellModel, imageLoader: imageLoader!)
		cellControllers[indexPath] = cellController
		return cellController
	}
    
    private func removeCellController(forRowAt indexPath: IndexPath) {
		cellControllers[indexPath] = nil
	}
}
