//
//  ManagedFeed.swift
//  RickAndMortyFeed
//
//  Created by Khristoffer Julio on 12/9/23.
//

import CoreData

@objc (ManagedFeed)
class ManagedFeed: NSManagedObject {
    @NSManaged var id: Int
    @NSManaged var name: String
    @NSManaged var status: String
    @NSManaged var species: String
    @NSManaged var type: String
    @NSManaged var gender: String
    @NSManaged var image: URL
    @NSManaged var data: Data?
}

extension ManagedFeed {
    static func first(with url: URL, in context: NSManagedObjectContext) throws -> Data? {
        if let data = context.userInfo[url] as? Data {
            return data
        }
        
        return try first(with: url, with: context)?.data
    }
    
    static func first(with image: URL, with context: NSManagedObjectContext) throws
    -> ManagedFeed? {
        let request = NSFetchRequest<ManagedFeed>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(ManagedFeed.image), image])
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
    static func images(from localFeed: [LocalCharacter], in context: NSManagedObjectContext) -> NSOrderedSet {
        let feeds = NSOrderedSet(array: localFeed.map { feed in
            let managedFeed = ManagedFeed(context: context)
            managedFeed.id = feed.id
            managedFeed.name = feed.name
            managedFeed.gender = feed.gender
            managedFeed.type = feed.type
            managedFeed.status = feed.status
            managedFeed.species = feed.species
            managedFeed.image = feed.image
            managedFeed.data = context.userInfo[feed.image] as? Data
            return managedFeed
        })
        context.userInfo.removeAllObjects()
        return feeds
    }
    
    static func data(with url: URL, in context: NSManagedObjectContext) -> Data? {
        if let data = context.userInfo[url] as? Data { return data }
        
        return try? first(with: url, in: context)
    }
    
    override func prepareForDeletion() {
        super.prepareForDeletion()
        managedObjectContext?.userInfo[image] = data
    }
}
