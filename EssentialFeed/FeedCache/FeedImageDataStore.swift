//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Romeo Flauta on 4/18/24.
//

import Foundation

public protocol FeedImageDataStore {
	typealias Result = Swift.Result<Data?, Error>

	func retrieve(dataForURL url: URL, completion: @escaping (Result) -> Void)
}
