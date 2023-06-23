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
        label.font = .systemFont(ofSize: 20)
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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var reviewButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 241 / 255, green: 155 / 255, blue: 145 / 255, alpha: 1.00)
        button.setTitle("나만의 리뷰 작성하기", for: .normal)
//        button.addTarget(self, action: #selector(), for: .touchUpInside)
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
        
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        
        movieImage.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        movieImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        movieImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
        movieImage.heightAnchor.constraint(equalTo: movieImage.widthAnchor, multiplier: 1.25).isActive = true
        
        summaryLabel.topAnchor.constraint(equalTo: movieImage.bottomAnchor, constant: 10).isActive = true
        summaryLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

        reviewButton.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 10).isActive = true
        reviewButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
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
