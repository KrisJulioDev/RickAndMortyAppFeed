//
//  ManagedCache.swift
//  RickAndMortyFeed
//
//  Created by Khristoffer Julio on 12/7/23.
//

import CoreData

@objc (ManagedCache)
class ManagedCache: NSManagedObject {
    @NSManaged var info: ManagedInfo
    @NSManaged var feed: NSOrderedSet
    
    var localCharacters: [LocalCharacter] {
        feed.compactMap { $0 as? ManagedFeed }.map {
            LocalCharacter(id: $0.id, name: $0.name, status: $0.status, species: $0.species, type: $0.type, gender: $0.gender, image: $0.image)
        }
    }
}

extension ManagedCache {
    static func find(in context: NSManagedObjectContext) throws -> ManagedCache? {
        let request = NSFetchRequest<ManagedCache>(entityName: entity().name!)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request).first
    }
    
    static func deleteCache(in context: NSManagedObjectContext) throws {
        try find(in: context).map(context.delete).map(context.save)
    }
    
    static func newUniqueInstance(from context: NSManagedObjectContext) throws -> ManagedCache{
        try deleteCache(in: context)
        return ManagedCache(context: context)
    }
}

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
}

@objc (ManagedInfo)
class ManagedInfo: NSManagedObject {
    @NSManaged var count: Int
    @NSManaged var pages: Int
    @NSManaged var next: String?
    @NSManaged var previous: String?
    
    var localInfo: Info {
        Info(count: count, pages: pages, next: next, prev: previous)
    }
    
    static func info(from info: Info, in context: NSManagedObjectContext) -> ManagedInfo {
        let managedInfo = ManagedInfo(context: context)
        managedInfo.count = info.count
        managedInfo.pages = info.pages
        managedInfo.next = info.next
        managedInfo.previous = info.prev
        return managedInfo
    }
}

