//
//  StarRatingView.swift
//  Movie_Practice
//
//  Created by 박진형 on 2023/05/16.
//

import UIKit

class StarRatingView: UIView {
    
    private let starCount = 5
    private let starSize: CGSize
    private var currentRating: Float
    lazy var starImageViews: [UIImageView] = (0..<starCount).map { _ in
        let starImageView = UIImageView(frame: CGRect(origin: .zero, size: starSize))
        starImageView.contentMode = .scaleAspectFit
        addSubview(starImageView)
        return starImageView
    }
    weak var delegate: StarRatingViewDelegate?
    
    init(frame: CGRect, initialRating: Float) {
        currentRating = initialRating
        starSize = CGSize(width: frame.width / CGFloat(starCount), height: frame.height)
        super.init(frame: frame)
        updateStarImages()
        setupGestureRecognizers()
        layoutStarRating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupGestureRecognizers() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: self)
        let newRating = calculateRating(from: location)
        
        if newRating != currentRating {
            currentRating = newRating
            updateStarImages()
            delegate?.starRatingView(self, didChangeRating: newRating)
        }
    }
    private func layoutStarRating() {
        let starSpacing: CGFloat = 10
        let starWidth = starSize.width
        let totalWidth = CGFloat(starCount) * (starWidth + starSpacing)
        var startX = (bounds.width - totalWidth) / 2
        if startX < 0 {
            startX = 0
        }
        let y = (bounds.height - starSize.height) / 2
        
        for (index, starImageView) in starImageViews.enumerated() {
            let x = startX + CGFloat(index) * (starWidth + starSpacing)
            starImageView.frame = CGRect(x: x, y: y, width: starWidth, height: starSize.height)
            print("Star \(index + 1) X Coordinate: \(x)")
        }
    }
    
    private func calculateRating(from location: CGPoint) -> Float {
        let clampedLocationX = max(0, min(location.x, frame.width))
        let newRating = Float(clampedLocationX / frame.width * CGFloat(starCount))
        return newRating
    }
    
    private func updateStarImages() {
        for (index, starImageView) in starImageViews.enumerated() {
            if Float(index) < currentRating {
                starImageView.image = UIImage(systemName: "star.fill")
            } else {
                starImageView.image = UIImage(systemName: "star")
            }
        }
    }
}

protocol StarRatingViewDelegate: AnyObject {
    func starRatingView(_ view: StarRatingView, didChangeRating rating: Float)
}
