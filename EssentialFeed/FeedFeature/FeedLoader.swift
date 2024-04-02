//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Romeo Flauta on 3/20/24.
//

import Foundation

public enum LoadFeedResult  {
    case success([FeedItem])
    case failure(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
