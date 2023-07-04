//
//  DetailViewController.swift
//  Movie_Practice
//
//  Created by 박진형 on 2023/05/14.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, StarRatingViewDelegate {
    var movie: Movie
    let movieManager = MovieManager.shared
    let localDataManager = LocalDataManager.shared
    lazy var dataSource: [Movie] = localDataManager.reviewedMovies
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.systemPink, for: .normal)
        button.setTitle("닫기", for: .normal)
        button.addTarget(self, action: #selector(onCloseButtonTapped), for: .touchUpInside)
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
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.systemPink, for: .normal)
        button.setTitle("저장", for: .normal)
        button.addTarget(self, action: #selector(onSaveButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        let defaultImage = UIImage(named: "default_thumbnail")
        imageView.image = defaultImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 3
        label.textColor = .black
        return label
    }()
    
    let directorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "감독: "
        label.font = .systemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()
    
    let actorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "배우: "
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 2 // 최대 2줄까지 보여줌
        label.lineBreakMode = .byTruncatingTail // 넘칠 경우 말줄임표로 표시
        label.textColor = .black
        return label
    }()
    
    lazy var starView = StarRatingView(frame: CGRect.zero, movie: movie)
    
    let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.text = "줄거리"
        return label
        
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .regular)
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
        textView.textContainer.maximumNumberOfLines = 0
        textView.textContainer.lineFragmentPadding = 0
        textView.text = movie.review
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.gray.cgColor
        return textView
    }()
    
    let infoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let labelStackView: UIView = {
        let stack = UIView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.clipsToBounds = true
        return stack
    }()
    
    
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
        starView.delegate = self
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
        
        descriptionLabel.text = movie.description
        directorLabel.text! += movie.director
        actorLabel.text! += movie.actor
        
        view.addSubview(closeButton)
        view.addSubview(reviewTitleLabel)
        view.addSubview(saveButton)
        
        view.addSubview(infoStackView)
        infoStackView.addArrangedSubview(thumbnailImageView)
        infoStackView.addArrangedSubview(labelStackView)
        
        labelStackView.addSubview(titleLabel)
        labelStackView.addSubview(directorLabel)
        labelStackView.addSubview(actorLabel)
        labelStackView.addSubview(starView)
        
        view.addSubview(descriptionTitleLabel)
        view.addSubview(descriptionLabel)
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
        
        infoStackView.topAnchor.constraint(equalTo: reviewTitleLabel.bottomAnchor, constant: 20).isActive = true
        infoStackView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 10).isActive = true
        infoStackView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -10).isActive = true
        infoStackView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        
        thumbnailImageView.heightAnchor.constraint(equalTo: thumbnailImageView.widthAnchor, multiplier: 1.25).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: labelStackView.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: labelStackView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: labelStackView.trailingAnchor).isActive = true
        
        directorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: margin).isActive = true
        directorLabel.leadingAnchor.constraint(equalTo: labelStackView.leadingAnchor).isActive = true
        directorLabel.trailingAnchor.constraint(equalTo: labelStackView.trailingAnchor).isActive = true
        
        let actorHeight = actorLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        actorLabel.heightAnchor.constraint(equalToConstant: actorHeight).isActive = true
        actorLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 45).isActive = true
        actorLabel.topAnchor.constraint(equalTo: directorLabel.bottomAnchor, constant: margin).isActive = true
        actorLabel.leadingAnchor.constraint(equalTo: labelStackView.leadingAnchor).isActive = true
        actorLabel.trailingAnchor.constraint(equalTo: labelStackView.trailingAnchor).isActive = true
        
        starView.translatesAutoresizingMaskIntoConstraints = false
        starView.topAnchor.constraint(equalTo: actorLabel.bottomAnchor, constant: 10).isActive = true
        starView.leadingAnchor.constraint(equalTo: labelStackView.leadingAnchor).isActive = true
        starView.bottomAnchor.constraint(equalTo: labelStackView.bottomAnchor).isActive = true
        
        let panGesture = UIPanGestureRecognizer(target: starView, action: #selector(starView.handlePanGesture(_:)))
        starView.addGestureRecognizer(panGesture)
        let tapGesture = UITapGestureRecognizer(target: starView, action: #selector(starView.handleTapGesture(_:)))
        starView.addGestureRecognizer(tapGesture)
        
        descriptionTitleLabel.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: 20).isActive = true
        descriptionTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin).isActive = true
        descriptionTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: margin).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin).isActive = true
        
        reviewLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20).isActive = true
        reviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin).isActive = true
        reviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin).isActive = true
        
        reviewTextView.topAnchor.constraint(equalTo: reviewLabel.bottomAnchor, constant:  margin).isActive = true
        reviewTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin).isActive = true
        reviewTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin).isActive = true
        reviewTextView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -margin).isActive = true
    }
    
    @objc func onSaveButtonTapped() {
        var tempMovie = self.movie
        //tempMovie 에는 actor 잘 들어감
        tempMovie.review = reviewTextView.text
        tempMovie.rating = starView.movie.rating

        localDataManager.saveMovieContext(with: tempMovie)
        NotificationCenter.default.post(name: NSNotification.Name("LocalDataDidChangeNotification"), object: nil)

        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func onCloseButtonTapped() {
        presentingViewController?.dismiss(animated: false, completion: nil)
        presentingViewController?.dismiss(animated: false, completion: nil)
//        self.dismiss(animated: true, completion: nil)
    }
    
    func starRatingView(_ view: StarRatingView, didChangeRating rating: Float) {
    }
}


