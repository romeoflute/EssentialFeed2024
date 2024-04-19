//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Romeo Flauta on 4/19/24.
//

import Foundation

public protocol FeedCache {
	typealias Result = Swift.Result<Void, Error>

	func save(_ feed: [FeedImage], completion: @escaping (Result) -> Void)
}
