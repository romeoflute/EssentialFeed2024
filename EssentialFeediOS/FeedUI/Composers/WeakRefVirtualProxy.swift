//
//  WeakRefVirtualProxy.swift
//  EssentialFeediOS
//
//  Created by Romeo Flauta on 4/15/24.
//  Lesson: https://alfredohdz.medium.com/proxy-design-pattern-f040a6561bfb

import UIKit
import EssentialFeed

final class WeakRefVirtualProxy<T: AnyObject> {
	private weak var object: T?

	init(_ object: T) {
		self.object = object
	}
}

extension WeakRefVirtualProxy: FeedLoadingView where T: FeedLoadingView {
	func display(_ viewModel: FeedLoadingViewModel) {
		object?.display(viewModel)
	}
}

extension WeakRefVirtualProxy: FeedImageView where T: FeedImageView, T.Image == UIImage {
	func display(_ model: FeedImageViewModel<UIImage>) {
		object?.display(model)
	}
}
