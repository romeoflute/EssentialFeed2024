//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Romeo Flauta on 4/10/24.
//

import UIKit

public final class FeedViewController: UITableViewController, UITableViewDataSourcePrefetching {
    @IBOutlet public var refreshController: FeedRefreshViewController?
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
