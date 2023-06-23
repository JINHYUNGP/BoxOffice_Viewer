//
//  DetailViewController.swift
//  Movie_Practice
//
//  Created by 박진형 on 2023/05/14.
//

import UIKit

class DetailViewController: UIViewController {
    
    var movie: Movie
    let movieManager = MovieManager.shared
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        return label
        
    }()
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        let thumbnailWidth: CGFloat = 120 // 이미지의 고정된 너비
        let thumbnailHeight: CGFloat = 160 // 이미지의 고정된 높이
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
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPink
        button.setTitle("저장하기", for: .normal)
        button.addTarget(self, action: #selector(onButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        configure()
        setAutoLayOut()
      
    }
    
    func configure() {
        titleLabel.text = movie.title
        if let url = URL(string: movie.selectedThumbnail ?? "") {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        self.thumbnailImageView.image = image
                    }
                }
            }
        }
        discriptionLable.text = movie.discription
        reviewTextView.textContainer.maximumNumberOfLines = 0
        reviewTextView.textContainer.lineFragmentPadding = 0

        
        view.addSubview(titleLabel)
        view.addSubview(thumbnailImageView)
        view.addSubview(discriptionLable)
        view.addSubview(reviewLabel)
        view.addSubview(reviewTextView)
        view.addSubview(saveButton)
    }
    
    func setAutoLayOut() {
        let guide = view.safeAreaLayoutGuide
        let margin: CGFloat = 10
        titleLabel.topAnchor.constraint(equalTo: guide.topAnchor ).isActive = true
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
        
        saveButton.topAnchor.constraint(equalTo: reviewTextView.bottomAnchor).isActive = true
        saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc func onButtonTapped(){
        
        var tempMovie = self.movie
        tempMovie.review = reviewTextView.text
        movieManager.reviewedMovies.append(tempMovie)
        self.dismiss(animated: true, completion: nil)
    }

}

