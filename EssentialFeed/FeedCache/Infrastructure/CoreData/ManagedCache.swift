//
//  ManagedCache.swift
//  EssentialFeed
//
//  Created by Romeo Flauta on 4/8/24.
//

import CoreData

@objc(ManagedCache)
class ManagedCache: NSManagedObject {

}

extension ManagedCache {
    
    @nonobjc private class func fetchRequest() -> NSFetchRequest<ManagedCache> {
        return NSFetchRequest<ManagedCache>(entityName: "ManagedCache")
    }
    
    @NSManaged var timestamp: Date
    @NSManaged var feed: NSOrderedSet
}

extension ManagedCache {
    static func find(in context: NSManagedObjectContext) throws -> ManagedCache? {
		let request = NSFetchRequest<ManagedCache>(entityName: entity().name!)
		request.returnsObjectsAsFaults = false
		return try context.fetch(request).first
	}
    
    static func newUniqueInstance(in context: NSManagedObjectContext) throws -> ManagedCache {
		try find(in: context).map(context.delete)
		return ManagedCache(context: context)
	}

    var localFeed: [LocalFeedImage] {
		return feed.compactMap { ($0 as? ManagedFeedImage)?.local }
	}
}

extension ManagedCache : Identifiable {

}
