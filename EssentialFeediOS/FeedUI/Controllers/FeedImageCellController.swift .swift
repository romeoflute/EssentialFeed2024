//
//  FeedImageCellController.swift .swift
//  EssentialFeed
//
//  Created by Romeo Flauta on 4/13/24.
//

import UIKit
import EssentialFeed

protocol FeedImageCellControllerDelegate {
	func didRequestImage()
	func didCancelImageRequest()
}

final class FeedImageCellController: FeedImageView {
	private let delegate: FeedImageCellControllerDelegate
    private var cell: FeedImageCell?

    init(delegate: FeedImageCellControllerDelegate) {
		self.delegate = delegate
	}

    func view(in tableView: UITableView) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        setAccessibility()
        delegate.didRequestImage()
		return cell!
	}

	func preload() {
        delegate.didRequestImage()
	}

    func cancelLoad() {
        releaseCellForReuse()
        delegate.didCancelImageRequest()
	}
    
    func display(_ viewModel: FeedImageViewModel<UIImage>) {
		cell?.locationContainer.isHidden = !viewModel.hasLocation
		cell?.locationLabel.text = viewModel.location
		cell?.descriptionLabel.text = viewModel.description
        cell?.feedImageView.setImageAnimated(viewModel.image)
        cell?.feedImageView.tag = viewModel.bytes ?? 0
		cell?.feedImageContainer.isShimmering = viewModel.isLoading
		cell?.feedImageRetryButton.isHidden = !viewModel.shouldRetry
		cell?.onRetry = delegate.didRequestImage
	}
    
    private func setAccessibility() {
        cell?.accessibilityIdentifier = "FeedImageCell"
        cell?.feedImageView.accessibilityIdentifier = "FeedImageView"
    }
    
    private func releaseCellForReuse() {
		cell = nil
	}
}
