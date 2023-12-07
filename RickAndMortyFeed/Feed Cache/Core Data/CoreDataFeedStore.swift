//
//  CoreDataFeedStore.swift
//  RickAndMortyFeed
//
//  Created by Khristoffer Julio on 12/7/23.
//

import CoreData

public class CoreDataFeedStore {
    private static let modelName = "FeedStore"
    private static let model = NSManagedObjectModel.withName(modelName, in: Bundle(for: CoreDataFeedStore.self))
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    enum StoreError: Error {
        case modelNotFound
        case failedToLoadPersistentContainer(Error)
    }
    
    public init(storeURL: URL) throws {
        guard let model = CoreDataFeedStore.model else {
            throw StoreError.modelNotFound
        }
        
        do {
            container = try NSPersistentContainer.load(
                modelName: CoreDataFeedStore.modelName,
                model: model,
                url: storeURL)
            
            context = container.newBackgroundContext()
        } catch {
            throw StoreError.failedToLoadPersistentContainer(error)
        }
    }
    
    func performSync<R>(_ action: (NSManagedObjectContext) -> Result<R, Error>) throws -> R {
        let context = self.context
        var result: Result<R, Error>!
        context.performAndWait { result = action(context) }
        return try result.get()
    }
    
    private func cleanUpReferencesToPersistentStores() {
        context.performAndWait {
            let coordinator = self.container.persistentStoreCoordinator
            try? coordinator.persistentStores.forEach(coordinator.remove)
        }
    }
    
    deinit {
        cleanUpReferencesToPersistentStores()
    }
}

extension CoreDataFeedStore: FeedStore {
    public func save(feed: [LocalCharacter], info: Info) throws {
        try performSync { context in
            Result {
                let managedCache = try ManagedCache.newUniqueInstance(from: context)
                managedCache.feed = ManagedFeed.images(from: feed, in: context)
                managedCache.info = ManagedInfo.info(from: info, in: context)
                try context.save()
            }
        }
    }
     
    public func retrieve() throws -> CacheFeed? {
        try performSync { context in
            Result {
                try ManagedCache.find(in: context).map {
                    CacheFeed(feed: $0.localCharacters, info: $0.info.localInfo)
                }
            }
        }
    }
    
    public func deleteCacheFeed() throws {
        try performSync { context in
            Result {
                try ManagedCache.deleteCache(in: context)
            }
        }
    }
}

extension NSManagedObjectModel {
    static func withName(_ name: String, in bundle: Bundle) -> NSManagedObjectModel? {
        bundle
            .url(forResource: name, withExtension: "momd")
            .flatMap { NSManagedObjectModel(contentsOf: $0) }
    }
}

