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
            LocalCharacter(id: $0.id, name: $0.name, status: $0.status, species: $0.species, type: $0.type, gender: $0.gender, image: $0.image, location: $0.location, origin: $0.origin)
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

