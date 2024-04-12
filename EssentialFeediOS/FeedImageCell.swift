//
//  FeedImageCell.swift
//  EssentialFeediOS
//
//  Created by Romeo Flauta on 4/10/24.
//

import UIKit

public final class FeedImageCell: UITableViewCell {
	public let locationContainer = UIView()
	public let locationLabel = UILabel()
	public let descriptionLabel = UILabel()
    public let feedImageContainer = UIView()
    public let feedImageView = UIImageView()
    
    private(set) public lazy var feedImageRetryButton: UIButton = {
		let button = UIButton()
		button.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
		return button
	}()

	var onRetry: (() -> Void)?

	@objc private func retryButtonTapped() {
		onRetry?()
	}
}