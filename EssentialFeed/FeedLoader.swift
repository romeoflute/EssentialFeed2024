//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Romeo Flauta on 3/20/24.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
