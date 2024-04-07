//
//  FeedCachePolicy.swift
//  EssentialFeed
//
//  Created by Romeo Flauta on 4/7/24.
//

import Foundation

// Lesson: make properties and functions static as this class does not hold state. It can also be a struct, or an enum without cases
final class FeedCachePolicy {
    private init() {}

    private static let calendar = Calendar(identifier: .gregorian)

    private static var maxCacheAgeInDays: Int {
        return 7
    }

    internal static func validate(_ timestamp: Date, against date: Date) -> Bool {
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else {
            return false
        }
        return date < maxCacheAge
    }
}
