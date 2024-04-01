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
        let items: [Item]
    }
    
    // convert Item decodable to FeedItem display type
    private struct Item: Decodable {
        let id: UUID
        let description: String?
        let location: String?
        let image: URL
        
        var item: FeedItem {
            return FeedItem(id: id, description: description, location: location, imageURL: image)
        }
    }
    
    static var OK_200: Int { return 200 }
    
    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [FeedItem] {
        guard response.statusCode == OK_200 else {
            throw RemoteFeedLoader.Error.invalidData
        }
        
        let root = try JSONDecoder().decode(Root.self, from: data)
        return root.items.map { $0.item }
    }
}

