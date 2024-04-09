//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Romeo Flauta on 3/20/24.
//

import Foundation

public protocol FeedLoader {
    typealias Result = Swift.Result<[FeedImage], Error>
    
    func load(completion: @escaping (Result) -> Void)
}
