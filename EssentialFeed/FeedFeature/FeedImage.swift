//
//  FeedImage.swift
//  EssentialFeed
//
//  Created by Romeo Flauta on 3/20/24.
//

import Foundation

// Lesson: for display only, not the codable type
public struct FeedImage: Hashable {
    public let id: UUID
    public let description: String?
    public let location: String?
    public let url: URL
    
    // even if struct is public, we need to have a public init to access it in the tests
    public init(id: UUID, description: String?, location: String?, url: URL) {
        self.id = id
        self.description = description
        self.location = location
        self.url = url
    }
}
