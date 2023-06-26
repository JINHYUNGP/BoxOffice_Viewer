//
//  ReviewViewController.swift
//  Movie_Practice
//
//  Created by 박진형 on 2023/05/10.
//

import UIKit
import CoreData

class ReviewViewController: UIViewController {
    
    let movieManager = MovieManager.shared
    var container:NSPersistentContainer!
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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
        
//        dataSource = movieManager.reviewedMovies
        self.tableView.delegate = self
        
        setUI()
        setAutoLayOut()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        dataSource = movieManager.reviewedMovies
        self.tableView.reloadData() // 테이블 뷰 업데이트 예시

        
    }
    
    func setUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.largeContentTitle = "리뷰한 영화"
        
    }
    
    func setAutoLayOut(){
        let guide = view.safeAreaLayoutGuide
        tableView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
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
extension ReviewViewController: UITableViewDataSource {
    // MARK: - UITableViewDataSource
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // 섹션 개수 반환
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // 섹션 제목 반환
        return "리뷰한 영화"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieManager.reviewedMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
        cell.contentView.addSubview(paddingView)
        cell.contentView.sendSubviewToBack(paddingView)
        cell.configure(with: movieManager.reviewedMovies[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
//
extension ReviewViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movieManager.reviewedMovies[indexPath.row]
        let detailViewController = DetailViewController(movie: movie)
        detailViewController.modalPresentationStyle = .popover
        present(detailViewController, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}
