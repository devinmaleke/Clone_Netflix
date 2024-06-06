//
//  SearchVC.swift
//  NetflixClone
//
//  Created by Cyberindo Sinergi Sistem on 01/04/24.
//

import UIKit

class SearchVC: UIViewController {
    
    private var titles : [Title] = [Title]()
    
    private let discoverTable: UITableView = {
        let table = UITableView()
        table.register(TitleTVC.self, forCellReuseIdentifier: TitleTVC.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(discoverTable)
        discoverTable.delegate = self
        discoverTable.dataSource = self
        
        fetchDiscoverMovies()
    }
    
    private func fetchDiscoverMovies(){
        APICaller.shared.getDiscoverMovies { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.discoverTable.reloadData()
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTVC.identifier, for: indexPath) as? TitleTVC else {
            return UITableViewCell()
        }
        
        let title = titles[indexPath.row]
        let model = TitleViewModel(titleName: (title.original_title ?? title.original_name) ?? "Unknown Title", posterURL: title.poster_path ?? "")
        cell.configure(with: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    
    
}
