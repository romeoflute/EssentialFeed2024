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
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Error) -> Void) {
        client.get(from: url) { result in
            switch result {
            case .success:
                completion(.invalidData)
            case .failure:
                // map from Swift Error to custom Error
                // lesson: client error should be mapped from Error in API Client to own domain Error in Loader class
                completion(.connectivity)
            }
        }
    }
}
