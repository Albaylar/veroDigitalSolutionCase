//
//  CoreDataManager.swift
//  veroDigitalSolutionCase
//
//  Created by Furkan Deniz Albaylar on 25.02.2024.
//


import Foundation
import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
        private let context: NSManagedObjectContext

        private init() {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                fatalError("AppDelegate not accessible.")
            }
            context = appDelegate.persistentContainer.viewContext
        }

    func saveCarsToCoreData(data: TaskModel?) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedObjectContext = appDelegate?.persistentContainer.viewContext
        
        if let entity = NSEntityDescription.entity(forEntityName: "Entity", in: managedObjectContext!),
           let taskItem = NSManagedObject(entity: entity, insertInto: managedObjectContext!) as? Entity {
            
                taskItem.task = data?.task
            taskItem.title = data?.title
            taskItem.taskDescription = data?.description
            taskItem.colorCode = data?.colorCode
            do {
                try managedObjectContext?.save()
                print("Saved to Core Data")
            } catch let error {
                print("Saving to Core Data failed: \(error.localizedDescription)")
            }
        }
    }
    func fetchAllItems() -> [TaskModel] {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedObjectContext = appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Entity>(entityName: "Entity")
        
        do {
            let entities = try managedObjectContext?.fetch(fetchRequest) ?? []
            let taskModels = entities.map { entity in
                TaskModel(task: entity.task, title: entity.title, description: entity.taskDescription, colorCode: entity.colorCode)
            }
            return taskModels
        } catch {
            print("Fetching from Core Data failed: \(error)")
            return []
        }
    }


}


