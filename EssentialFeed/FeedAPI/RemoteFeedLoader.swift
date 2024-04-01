//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Romeo Flauta on 3/26/24.
//

import Foundation

// Lesson: restrict result to 2
public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    // Lesson: catch not only the error but status code as well
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

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
                if response.statusCode == 200, let root = try? JSONDecoder().decode(Root.self, from: data) {
                    completion(.success(root.items.map { $0.item }))
                } else {
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

// Lesson: Decodable belongs to the Remote loader Feed API and not the Feed Feature for display
private struct Root: Decodable {
    let items: [Item]
}

private struct Item: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
    
    // convert Item decodable to FeedItem display type
    var item: FeedItem {
        return FeedItem(id: id, description: description, location: location, imageURL: image)
    }
}
