//
//  CoreDataHelpers.swift
//  RickAndMortyFeed
//
//  Created by Khristoffer Julio on 12/7/23.
//

import CoreData

extension NSPersistentContainer {
    static func load(modelName: String, model: NSManagedObjectModel, url: URL) throws -> NSPersistentContainer {
        
        let description = NSPersistentStoreDescription(url: url)
        let container = NSPersistentContainer(name: modelName, managedObjectModel: model)
        container.persistentStoreDescriptions = [description]
        
        var loadError: Swift.Error?
        container.loadPersistentStores { loadError = $1 }
        try loadError.map { throw $0 }
            
        return container
    }
}
