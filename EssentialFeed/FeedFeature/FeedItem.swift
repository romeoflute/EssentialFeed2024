//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Romeo Flauta on 3/20/24.
//

import Foundation

// Lesson: for display only, not the codable type
public struct FeedItem: Equatable {
    public let id: UUID
    public let description: String?
    public let location: String?
    public let imageURL: URL
    
    public init(id: UUID, description: String?, location: String?, imageURL: URL) {
        self.id = id
        self.description = description
        self.location = location
        self.imageURL = imageURL
    }
}
