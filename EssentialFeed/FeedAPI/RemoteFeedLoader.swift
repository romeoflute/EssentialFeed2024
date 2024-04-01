//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Romeo Flauta on 3/26/24.
//

import Foundation

public final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public enum Result: Equatable {
        case success([FeedItem])
        case failure(Error)
    }
    
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case let .success(data, response):
                do {
                    let items = try FeedItemsMapper.map(data, response)
                    completion(.success(items))
                } catch {
                    completion(.failure(.invalidData))
                }
            case .failure:
                // map from Swift Error to custom Error
                // lesson: client error should be mapped from Error in API Client to own domain Error in Loader class
                completion(.failure(.connectivity))
            }
        }
    }
}
