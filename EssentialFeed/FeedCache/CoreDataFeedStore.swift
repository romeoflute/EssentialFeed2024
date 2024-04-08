//
//  CoreDataFeedStore.swift
//  EssentialFeed
//
//  Created by Romeo Flauta on 4/8/24.
//

import Foundation
import CoreData

public final class CoreDataFeedStore: FeedStore {
    private let container: NSPersistentContainer
    
    public init() throws {
        container = NSPersistentContainer(name: "FeedStore")
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.empty)
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        
    }
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        
    }
}

@objc(ManagedFeedImage)
private class ManagedFeedImage: NSManagedObject {

}

extension ManagedFeedImage {

    @nonobjc private class func fetchRequest() -> NSFetchRequest<ManagedFeedImage> {
        return NSFetchRequest<ManagedFeedImage>(entityName: "ManagedFeedImage")
    }

    @NSManaged var id: UUID?
    @NSManaged var imageDescription: String?
    @NSManaged var location: String?
    @NSManaged var url: URL?
    @NSManaged var cache: ManagedCache?

}

extension ManagedFeedImage : Identifiable {

}

@objc(ManagedCache)
private class ManagedCache: NSManagedObject {

}

extension ManagedCache {

    @nonobjc private class func fetchRequest() -> NSFetchRequest<ManagedCache> {
        return NSFetchRequest<ManagedCache>(entityName: "ManagedCache")
    }

    @NSManaged var timestamp: Date?
    @NSManaged var feed: NSOrderedSet?

}

// MARK: Generated accessors for feed
extension ManagedCache {

    @objc(insertObject:inFeedAtIndex:)
    @NSManaged func insertIntoFeed(_ value: ManagedFeedImage, at idx: Int)

    @objc(removeObjectFromFeedAtIndex:)
    @NSManaged public func removeFromFeed(at idx: Int)

    @objc(insertFeed:atIndexes:)
    @NSManaged func insertIntoFeed(_ values: [ManagedFeedImage], at indexes: NSIndexSet)

    @objc(removeFeedAtIndexes:)
    @NSManaged func removeFromFeed(at indexes: NSIndexSet)

    @objc(replaceObjectInFeedAtIndex:withObject:)
    @NSManaged func replaceFeed(at idx: Int, with value: ManagedFeedImage)

    @objc(replaceFeedAtIndexes:withFeed:)
    @NSManaged func replaceFeed(at indexes: NSIndexSet, with values: [ManagedFeedImage])

    @objc(addFeedObject:)
    @NSManaged func addToFeed(_ value: ManagedFeedImage)

    @objc(removeFeedObject:)
    @NSManaged func removeFromFeed(_ value: ManagedFeedImage)

    @objc(addFeed:)
    @NSManaged func addToFeed(_ values: NSOrderedSet)

    @objc(removeFeed:)
    @NSManaged func removeFromFeed(_ values: NSOrderedSet)

}

extension ManagedCache : Identifiable {

}

private extension NSPersistentContainer {
	enum LoadingError: Swift.Error {
		case modelNotFound
		case failedToLoadPersistentStores(Swift.Error)
	}

	static func load(modelName name: String, in bundle: Bundle) throws -> NSPersistentContainer {
		guard let model = NSManagedObjectModel.with(name: name, in: bundle) else {
			throw LoadingError.modelNotFound
		}

		let container = NSPersistentContainer(name: name, managedObjectModel: model)
		var loadError: Swift.Error?
		container.loadPersistentStores { loadError = $1 }
		try loadError.map { throw LoadingError.failedToLoadPersistentStores($0) }

		return container
	}
}

private extension NSManagedObjectModel {
	static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
		return bundle
			.url(forResource: name, withExtension: "momd")
			.flatMap { NSManagedObjectModel(contentsOf: $0) }
	}
}
