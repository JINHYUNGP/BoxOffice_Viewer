//
//  StarRatingView.swift
//  Movie_Practice
//
//  Created by 박진형 on 2023/05/16.
//
import UIKit

class StarRatingView: UIView {
    var movie: Movie
    private let starCount = 5
    private let starSize: CGSize
    private var currentRating: Float = 0
    weak var delegate: StarRatingViewDelegate?
    
    let starImage: UIImage = UIImage(systemName: "star")!.withTintColor(.systemOrange, renderingMode: .alwaysOriginal)
    let starFilledImage: UIImage = UIImage(systemName: "star.fill")!.withTintColor(.systemOrange, renderingMode: .alwaysOriginal)
    
    let stackView = UIStackView()
    
    var starLabel: UILabel = {
        let label = UILabel()
        label.text = "score: "
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(frame: CGRect, movie: Movie) {
        starSize = CGSize(width: frame.width / CGFloat(starCount), height: frame.height)
        self.movie = movie
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        stackView.axis = .horizontal
        stackView.spacing = 3
        
        for _ in 0..<Int(movie.rating) {
            let imageView = UIImageView(image: starFilledImage)
            imageView.contentMode = .scaleAspectFit
            stackView.addArrangedSubview(imageView)
        }
        for _ in 0..<5-Int(movie.rating) {
            let imageView = UIImageView(image: starImage)
            imageView.contentMode = .scaleAspectFit
            stackView.addArrangedSubview(imageView)
        }
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    // 드래그 제스처 핸들러
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: self)
        let starWidth = bounds.width / CGFloat(starCount)
        let selectedStarIndex = Int(location.x / starWidth)
        let newRating = Float(selectedStarIndex + 1)
        
        if newRating != currentRating {
            currentRating = newRating
            updateStarImages()
            delegate?.starRatingView(self, didChangeRating: newRating)
        }
    }
    
    // 클릭 제스처 핸들러
    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self)
        let starWidth = bounds.width / CGFloat(starCount)
        let selectedStarIndex = Int(location.x / starWidth)
        let newRating = Float(selectedStarIndex + 1)

        if newRating != currentRating {
            currentRating = newRating
            movie.rating = Double(newRating)
            print(movie)
            updateStarImages()
            delegate?.starRatingView(self, didChangeRating: newRating)
        }
    }
    
    // 별 이미지 업데이트
    private func updateStarImages() {
        for (index, imageView) in stackView.arrangedSubviews.enumerated() {
            guard let starImageView = imageView as? UIImageView else { continue }
            
            if Float(index) < currentRating {
                starImageView.image = starFilledImage
            } else {
                starImageView.image = starImage
            }
        }
    }
}

protocol StarRatingViewDelegate: AnyObject {
    func starRatingView(_ view: StarRatingView, didChangeRating rating: Float)
}
