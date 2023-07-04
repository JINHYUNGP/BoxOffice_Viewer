//
//  CustomModalView.swift
//  Movie_Practice
//
//  Created by 이주희 on 2023/06/23.
//
import UIKit

class CustomModalView: UIView {

    lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("X", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "title"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var movieImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var summaryLabel: UILabel = {
        let label = UILabel()
        label.text = "summary"
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 10
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var reviewButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 241 / 255, green: 155 / 255, blue: 145 / 255, alpha: 1.00)
        button.setTitle("나만의 리뷰 작성하기", for: .normal)
//        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 8.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createViews()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createViews()
        setupView()
    }
    
    private func createViews() {
        backgroundColor = UIColor(red: 253 / 255, green: 239 / 255, blue: 228 / 255, alpha: 1.00)
        addSubview(titleLabel)
        addSubview(closeButton)
        addSubview(movieImage)
        addSubview(summaryLabel)
        addSubview(reviewButton)
    }
    private func setupView() {
        
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        
        closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        
        movieImage.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        movieImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        movieImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
        movieImage.heightAnchor.constraint(equalTo: movieImage.widthAnchor, multiplier: 1.25).isActive = true
        
        summaryLabel.topAnchor.constraint(equalTo: movieImage.bottomAnchor, constant: 10).isActive = true
        summaryLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        summaryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        summaryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
//        starView?.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 10).isActive = true

        reviewButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        reviewButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        reviewButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        reviewButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        reviewButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc private func closeButtonTapped() {
        if let viewController = findViewController() {
            viewController.dismiss(animated: false, completion: nil)
        }
    }
    
    private func findViewController() -> UIViewController? {
        var nextResponder: UIResponder? = self
        while let responder = nextResponder {
            if let viewController = responder as? UIViewController {
                return viewController
            }
            nextResponder = responder.next
        }
        return nil
    }
    
}
