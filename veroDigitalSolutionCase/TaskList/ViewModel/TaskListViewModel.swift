//
//  TaskListViewModel.swift
//  veroDigitalSolutionCase
//
//  Created by Furkan Deniz Albaylar on 26.02.2024.
//

import Foundation


class TaskListViewModel {
    private var tasks: [TaskModel] = []
    
    func fetchTasks(completion: @escaping ([TaskModel]) -> Void) {
        if InternetManager.shared.isInternetActive() {
            Service.shared.login { result in
                switch result {
                case .success(let accessToken):
                    Service.shared.fetchData { result in
                        switch result {
                        case .success(let tasks):
                            self.tasks = tasks
                            completion(tasks)
                        case .failure(let error):
                            print("Veri alınamadı: \(error)")
                            completion([])
                        }
                    }
                case .failure(let error):
                    print("Giriş yapılamadı: \(error)")
                    completion([])
                }
            }
        } else {
            self.tasks = CoreDataManager.shared.fetchAllItems()
            completion(self.tasks)
        }
    }
    
    func filterTasksAlphabetically() {
        tasks.sort { $0.title ?? "" < $1.title ?? "" }
    }
}
