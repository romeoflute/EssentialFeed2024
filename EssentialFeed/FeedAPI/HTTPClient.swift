//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Romeo Flauta on 4/1/24.
//

import Foundation

public protocol HTTPClientTask {
	func cancel()
}

public protocol HTTPClient {
    // Lesson: catch not only the error but status code as well
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    /// The completion handler can be invoked in any thread.
	/// Clients are responsible to dispatch to appropriate threads, if needed.
    @discardableResult
	func get(from url: URL, completion: @escaping (Result) -> Void) -> HTTPClientTask
}

