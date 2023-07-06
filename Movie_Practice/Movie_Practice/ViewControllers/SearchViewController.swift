//
//  SearchViewController.swift
//  Movie_Practice
//
//  Created by 박진형 on 2023/05/10.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate {
    let movieManager = MovieManager.shared
    var tableView = UITableView()
    var searchBar = UISearchBar()
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setUI()
        setAutoLayOut()
    }
    
    func configure() {
        // UITableView 생성 및 설정
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 160
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
        
        // UISearchBar 설정
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "검색"
        searchBar.delegate = self
        view.addSubview(searchBar)
    }
    
    func setUI() {
        view.backgroundColor = .white
        title = "검색"
    }
    
    func setAutoLayOut() {
        let guide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            // searchBar의 제약 조건 설정
            searchBar.topAnchor.constraint(equalTo: guide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            
            // tableView의 제약 조건 설정
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor)
        ])
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell

        if cell.starRatingView.superview != nil {
            cell.starRatingView.removeFromSuperview()
        }
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
        cell.contentView.addSubview(paddingView)
        cell.contentView.sendSubviewToBack(paddingView)
        cell.configure(with: movies[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        let modalVC = CustomModalViewController(movie: movie)
        
        // 모달 스타일 설정
        modalVC.modalPresentationStyle = .overFullScreen
        modalVC.modalTransitionStyle = .crossDissolve
        
        // 배경 터치로 모달 닫기 설정
        modalVC.isModalInPresentation = true
        modalVC.didDismissModal = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        present(modalVC, animated: false, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("function is calling")
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        guard let searchText = searchBar.text else {
            return
        }
        print("im here")
        print("currentStartCount + 10", movieManager.currentStartCount + 10 )
        print("maxcount", movieManager.maxCount)
        if indexPath.row == lastRowIndex && movieManager.currentStartCount + 10 < movieManager.maxCount {
            movieManager.currentStartCount += 10 // 다음 페이지로 이동
            
            let movieManager = MovieManager.shared
            movieManager.fetchAllMovies(with: searchText, startCount: movieManager.currentStartCount ) { [weak self] movies in
                guard let additionalMovies = movies else {
                    return
                }
                
                self?.movies += additionalMovies
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        movieManager.fetchAllMovies(with: searchText) { [weak self] movies in
            guard let movies = movies else {
                return
            }
            
            self?.movies = movies.sorted(by: { $0.movieCd > $1.movieCd })
            
            DispatchQueue.main.async {
                self?.tableView.reloadData() // 테이블 뷰 업데이트 예시
            }
        }
        
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text else {
            return
        }
        movieManager.setCurrentStartCountZero()
        movieManager.fetchAllMovies(with: searchText) { [weak self] movies in
            
            self?.movies = movies ?? [Movie()]
            
            DispatchQueue.main.async {
                self?.tableView.reloadData() // 테이블 뷰 업데이트 예시
            }
        }
    }
    
    
}
