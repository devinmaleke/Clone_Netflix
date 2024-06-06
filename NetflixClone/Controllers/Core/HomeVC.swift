//
//  HomeVC.swift
//  NetflixClone
//
//  Created by Cyberindo Sinergi Sistem on 01/04/24.
//

import UIKit

enum Section: Int{
    case TrendingMovies = 0
    case TrendingTV = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomeVC: UIViewController {
    
    let sectionTitles : [String] = ["trending Movies", "Trending TV","Popular","Upcoming Movies", "Top Rated"]
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTVC.self, forCellReuseIdentifier: CollectionViewTVC.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavBar()
        
        let headerView = HomeHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        homeFeedTable.tableHeaderView = headerView
        
        
    }
    
    private func configureNavBar(){
        var image = UIImage(named: "NetflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        // Create UIImageView for Netflix logo
        let logoImageView = UIImageView(image: image)
        
        // Set the width and height constraint for logoImageView
        logoImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true // You can adjust the width as needed
        logoImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true // You can adjust the width as needed
        
        // Set logo as left bar button item
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoImageView)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil),
        ]
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTVC.identifier, for: indexPath) as? CollectionViewTVC else{
            return UITableViewCell()
        }
        
        switch indexPath.section{
        case Section.TrendingMovies.rawValue:
            APICaller.shared.getTrendingMovies { result in
                switch result{
                case.success(let titles):
                    cell.configure(with: titles)
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Section.TrendingTV.rawValue:
            APICaller.shared.getTrendingTVs { result in
                switch result{
                case.success(let titles):
                    cell.configure(with: titles)
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Section.Popular.rawValue:
            APICaller.shared.getPopularMovies { result in
                switch result{
                case.success(let titles):
                    cell.configure(with: titles)
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Section.Upcoming.rawValue:
            APICaller.shared.upcomingMovies { result in
                switch result{
                case.success(let titles):
                    cell.configure(with: titles)
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Section.TopRated.rawValue:
            APICaller.shared.getTopRatedMovies { result in
                switch result{
                case.success(let titles):
                    cell.configure(with: titles)
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
}
