//
//  HomeViewController.swift
//  Movie_Practice
//
//  Created by 박진형 on 2023/05/10.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    let movieManager = MovieManager.shared
    let localDataManager = LocalDataManager.shared
    var dataSource: [Movie] = []
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.rowHeight = 150
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        self.tableView.delegate = self
        
        setUI()
        setAutoLayOut()
        NotificationCenter.default.addObserver(self, selector: #selector(handleLocalDataChangeNotification(_:)), name: NSNotification.Name("LocalDataDidChangeNotification"), object: nil)
    }
    
    func setUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.largeContentTitle = "현재 상영작"
        
    }
    
    func setAutoLayOut(){
        let guide = view.safeAreaLayoutGuide
        tableView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
    }
    
    func loadData() {
        movieManager.fetchMovies { [weak self] movies in
            let sortedMovies = movies.sorted { $0.rank < $1.rank }
            
            if let localMovies = self?.localDataManager.reviewedMovies {
                self?.updateDataSource(sortedMovies: sortedMovies, localMovies: localMovies)
            } else {
                self?.dataSource = sortedMovies
            }
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func updateDataSource(sortedMovies: [Movie], localMovies: [Movie]) {
        dataSource = sortedMovies.map { sortedMovie in
            if let updatedMovie = localMovies.first(where: { $0.movieCd == sortedMovie.movieCd }) {
                return updatedMovie
            } else {
                return sortedMovie
            }
        }
    }
    
    @objc func handleLocalDataChangeNotification(_ notification: Notification) {
        loadData()
    }
}

extension HomeViewController: UITableViewDataSource {
    // MARK: - UITableViewDataSource
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // 섹션 개수 반환
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // 섹션 제목 반환
        return "현재 상영작"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        // 스크롤 시 셀이 재사용되더라도 겹치는 뷰 제어 가능
        if cell.starRatingView.superview != nil {
            cell.starRatingView.removeFromSuperview()
        }
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
        cell.contentView.addSubview(paddingView)
        cell.contentView.sendSubviewToBack(paddingView)
        cell.isRankVisible = true
        cell.configure(with: dataSource[indexPath.row])
        
        return cell
    }
}

// MARK: - UITableViewDelegate
//
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = dataSource[indexPath.row]
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}
