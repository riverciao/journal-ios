//
//  CoreDataHandler.swift
//  Patissier
//
//  Created by riverciao on 2017/11/13.
//  Copyright © 2017年 riverciao. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHandler: NSObject {
    
    private class func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    
    class func saveObject(title: String, content: String, image: Data, timestamp: Date) {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Item", in: context)
        let managedObject = NSManagedObject(entity: entity!, insertInto: context)
        
        managedObject.setValue(title, forKey: "title")
        managedObject.setValue(content, forKey: "content")
        managedObject.setValue(image, forKey: "image")
        managedObject.setValue(timestamp, forKey: "timestamp")
        
        do {
            try context.save()
        } catch let error {
            print("saveObject error: \(error)")
        }
    }
    
    class func updateObject(title: String, content: String, image: Data) {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Item", in: context)
        let managedObject = NSManagedObject(entity: entity!, insertInto: context)
        
        managedObject.setValue(title, forKey: "title")
        managedObject.setValue(content, forKey: "content")
        managedObject.setValue(image, forKey: "image")
        
        do {
            try context.save()
        } catch let error {
            print("saveObject error: \(error)")
        }
    }
    
    class func fetchObject() -> [Item]? {
        let context = getContext()
        var items: [Item]? = nil
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
            items = try context.fetch(fetchRequest)
            return items
        } catch let error {
            print("fetchObject error: \(error)")
            return items
        }
    }
    
    class func deleteObject(item: Item) {
        let context = getContext()
        context.delete(item)
        
        do {
            try context.save()
        } catch let error {
            print("deleteObject error: \(error)")
        }
    }
    
    class func deleteAllObject() {
        let context = getContext()
        let delete = NSBatchDeleteRequest(fetchRequest: Item.fetchRequest())
        
        do {
            try context.execute(delete)
        } catch let error {
            print("deleteAllObject error: \(error)")
        }
    }
    
    class func filterData(selectedProductId: String) -> [Item]? {
        let context = getContext()
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        var items: [Item] = []
        
        let predicate = NSPredicate(format: "productId == %@", selectedProductId)
        fetchRequest.predicate = predicate
        
        do {
            items = try context.fetch(fetchRequest)
            return items
        } catch let error {
            print("filterData error: \(error)")
            return items
        }
    }

}
