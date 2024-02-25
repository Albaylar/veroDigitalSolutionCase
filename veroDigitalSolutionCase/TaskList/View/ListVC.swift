//
//  ViewController.swift
//  veroDigitalSolutionCase
//
//  Created by Furkan Deniz Albaylar on 20.02.2024.
//

import UIKit
import SnapKit

class ListVC: UIViewController {
    
    let tableView = UITableView()
    var tasks: [TaskModel] = []
    let searchBar = UISearchBar()
    var refreshControl = UIRefreshControl()
    let filterButton = UIButton(type: .system)
    var selectedColor: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
        
        
    }


    
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.layer.cornerRadius = 20
        
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.right.left.equalToSuperview().inset(10)
            make.height.equalTo(50)
        }
        let refreshButton = UIButton()
        refreshButton.setImage(UIImage(systemName: "arrow.uturn.down"), for: .normal)
        refreshButton.backgroundColor = .gray
        refreshButton.tintColor = .white
        refreshButton.layer.cornerRadius = 15
        refreshButton.addTarget(self, action: #selector(refreshData), for: .touchUpInside)
        
        view.addSubview(refreshButton)
        refreshButton.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(30)
            make.width.equalTo(50)
            make.height.equalTo(35)
            
        }
        filterButton.setTitle("Filter by Alphabetically", for: .normal)
        filterButton.setTitleColor(.white, for: .normal)
        filterButton.backgroundColor = .gray
        filterButton.layer.cornerRadius = 15
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        
        view.addSubview(filterButton)
        filterButton.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.right.equalToSuperview().inset(30)
            make.left.equalTo(refreshButton.snp.right).offset(100)
            make.height.equalTo(35)
            
        }
        
        view.addSubview(tableView)
        tableView.layer.cornerRadius = 10
        tableView.snp.makeConstraints { make in
            make.top.equalTo(filterButton.snp.bottom).offset(10)
            make.right.left.equalToSuperview().inset(5)
            make.bottom.equalToSuperview()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ListCell.self, forCellReuseIdentifier: "cell")
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    func fetchData() {
        if InternetManager.shared.isInternetActive() {
            // İnternet bağlantısı varsa
            Service.shared.login { result in
                switch result {
                case .success(let accessToken):
                    Service.shared.fetchData { result in
                        switch result {
                        case .success(let tasks):
                            self.tasks = tasks
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                for task in tasks {
                                    CoreDataManager.shared.saveCarsToCoreData(data: task)
                                }
                            }
                        case .failure(let error):
                            print("Veri alınamadı: \(error)")
                        }
                    }
                case .failure(let error):
                    print("Giriş yapılamadı: \(error)")
                }
            }
        } else {
            tasks = CoreDataManager.shared.fetchAllItems()
            tableView.reloadData()
        }
        refreshControl.endRefreshing()
    }
    
    
    
    func filterTasksAlphabetically() {
        tasks.sort { $0.title ?? "" < $1.title ?? "" }
        tableView.reloadData()
    }
    
    @objc func refreshData() {
        fetchData()
    }
    
    @objc func filterButtonTapped() {
        filterTasksAlphabetically()
    }
    
}

extension ListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ListCell
        let task = tasks[indexPath.row]
        cell.configure(with: task)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

extension ListVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        searchForText(searchText)
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchForText("")
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
}

extension ListVC {
    func searchForText(_ text: String) {
        let filteredTasks = tasks.filter { task in
            let mirror = Mirror(reflecting: task)
            for case let (label?, value) in mirror.children {
                if let stringRepresentation = value as? String,
                   stringRepresentation.localizedCaseInsensitiveContains(text) {
                    return true
                }
            }
            return false
        }
        self.tasks = filteredTasks
        self.tableView.reloadData()
    }
}







