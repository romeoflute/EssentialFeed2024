//
//  ManagedFeedImage.swift
//  EssentialFeed
//
//  Created by Romeo Flauta on 4/8/24.
//

import CoreData

@objc(ManagedFeedImage)
class ManagedFeedImage: NSManagedObject {

}

extension ManagedFeedImage {
    
    @nonobjc private class func fetchRequest() -> NSFetchRequest<ManagedFeedImage> {
        return NSFetchRequest<ManagedFeedImage>(entityName: "ManagedFeedImage")
    }
    
    @NSManaged var id: UUID
    @NSManaged var imageDescription: String?
    @NSManaged var location: String?
    @NSManaged var url: URL
    @NSManaged var cache: ManagedCache
}

extension ManagedFeedImage {
    static func images(from localFeed: [LocalFeedImage], in context: NSManagedObjectContext) -> NSOrderedSet {
		return NSOrderedSet(array: localFeed.map { local in
			let managed = ManagedFeedImage(context: context)
			managed.id = local.id
			managed.imageDescription = local.description
			managed.location = local.location
			managed.url = local.url
			return managed
		})
	}

	var local: LocalFeedImage {
		return LocalFeedImage(id: id, description: imageDescription, location: location, url: url)
	}
}

extension ManagedFeedImage : Identifiable {

}
