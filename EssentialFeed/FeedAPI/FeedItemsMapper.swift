//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Romeo Flauta on 4/1/24.
//

import Foundation

// Lesson: Decodable belongs to the Feed API and not the Feed Feature for display
// Lesson: Create a dedicated mapper
final class FeedItemsMapper {
    private struct Root: Decodable {
        let items: [RemoteFeedItem]
    }
    
    static var OK_200: Int { return 200 }
    
    internal static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard response.statusCode == OK_200,
              let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteFeedLoader.Error.invalidData
        }
        
        return root.items
    }
}

