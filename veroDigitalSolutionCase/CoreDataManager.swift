//
//  CoreDataManager.swift
//  veroDigitalSolutionCase
//
//  Created by Furkan Deniz Albaylar on 23.02.2024.
//

import Foundation

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "Entity")
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchTasks() -> [TaskModel] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TaskModel> = Task.fetchRequest()
        do {
            let tasks = try context.fetch(fetchRequest)
            return tasks
        } catch {
            print("Error fetching tasks: \(error)")
            return []
        }
    }
}
