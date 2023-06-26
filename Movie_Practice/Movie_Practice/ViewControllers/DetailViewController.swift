//
//  DetailViewController.swift
//  Movie_Practice
//
//  Created by 박진형 on 2023/05/14.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    var movie: Movie
    let movieManager = MovieManager.shared
    var container: NSPersistentContainer!
    
    var closeButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.systemPink, for: .normal)
        button.setTitle("닫기", for: .normal)
//        button.addTarget(self, action: #selector(), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let reviewTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "리뷰 작성"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.systemPink, for: .normal)
        button.setTitle("저장", for: .normal)
        button.addTarget(self, action: #selector(onButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        let defaultImage = UIImage(named: "default_thumbnail")
        imageView.image = defaultImage
        let thumbnailWidth: CGFloat = 90 // 이미지의 고정된 너비
        let thumbnailHeight: CGFloat = 120 // 이미지의 고정된 높이
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let discriptionLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    let reviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.text = "나의 감상평"
        return label
        
    }()
    
    lazy var reviewTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = movie.review
        return textView
    }()
    
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
        let entity = NSEntityDescription.entity(forEntityName: "Movie", in: self.container.viewContext)
        
        configure()
        setAutoLayOut()
    }
    
    func configure() {
        titleLabel.text = movie.title
        if let thumbnailURLString = movie.selectedThumbnail, let thumbnailURL = URL(string: thumbnailURLString) {
            URLSession.shared.dataTask(with: thumbnailURL) { (data, response, error) in
                if let error = error {
                    print("Error downloading thumbnail image: \(error.localizedDescription)")
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.thumbnailImageView.image = image
                    }
                }
            }.resume()
        } else {
            // 기본 이미지 설정
            let defaultImage = UIImage(systemName: "film")
            thumbnailImageView.image = defaultImage
        }
        discriptionLable.text = movie.description
        reviewTextView.textContainer.maximumNumberOfLines = 0
        reviewTextView.textContainer.lineFragmentPadding = 0

        view.addSubview(closeButton)
        view.addSubview(reviewTitleLabel)
        view.addSubview(saveButton)
        view.addSubview(titleLabel)
        view.addSubview(thumbnailImageView)
        view.addSubview(discriptionLable)
        view.addSubview(reviewLabel)
        view.addSubview(reviewTextView)
    }
    
    func setAutoLayOut() {
        let guide = view.safeAreaLayoutGuide
        let margin: CGFloat = 10
        
        closeButton.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        closeButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 10).isActive = true
        
        reviewTitleLabel.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        reviewTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        saveButton.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -10).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: reviewTitleLabel.bottomAnchor, constant: 10).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        thumbnailImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        thumbnailImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        discriptionLable.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor).isActive = true
        discriptionLable.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        discriptionLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin).isActive = true
        discriptionLable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: margin).isActive = true
        
        reviewLabel.topAnchor.constraint(equalTo: discriptionLable.bottomAnchor).isActive = true
        reviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin).isActive = true
        reviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin).isActive = true
        
        reviewTextView.topAnchor.constraint(equalTo: reviewLabel.bottomAnchor).isActive = true
        reviewTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        reviewTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin).isActive = true
        reviewTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin).isActive = true
        reviewTextView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
    }
    
    @objc func onButtonTapped(){
        var tempMovie = self.movie
        tempMovie.review = reviewTextView.text
        movieManager.reviewedMovies.append(tempMovie)
        
        let context = container.viewContext
        let movie = MovieCoreDataModel(context: context)
        movie.title = tempMovie.title
        movie.actor = tempMovie.actor
        movie.movieDescription = tempMovie.description
        movie.rank = Int32(tempMovie.rank)
        movie.rating = tempMovie.rating
        movie.review = tempMovie.review
        movie.thumbnailImage = tempMovie.thumbnailImage
        movie.director = tempMovie.director
        
        do {
            try context.save()
            print("영화 '괴물'이 CoreData에 저장되었습니다.")
        } catch {
            print("데이터 저장 실패: \(error)")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
