//
//  TableViewCell.swift
//  Movie_Practice
//
//  Created by 박진형 on 2023/05/14.
//

import UIKit

class TableViewCell: UITableViewCell {
    static let identifier = "cell"
    var movie = Movie()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.lineBreakMode = .byTruncatingTail // 너비를 초과하는 경우 생략 부호로 표시
        label.numberOfLines = 1 // 단일 라인으로 표시
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let directorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let actorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 2 // 최대 2줄까지 보여줌
        label.lineBreakMode = .byTruncatingTail // 넘칠 경우 말줄임표로 표시
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true // 이미지를 프레임 내에서 자르기
        return imageView
    }()
    
    lazy var starRatingView = StarRatingView(frame: CGRect.zero, movie: movie)
    
    let ratingStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        
        directorLabel.text = "감독: " + movie.director.removeLeadingCommaSpace()
        actorLabel.text = "배우: " + movie.actor.removeLeadingCommaSpace()
        ratingLabel.text = "평점: "
        
        starRatingView = StarRatingView(frame: CGRect.zero, movie: movie)
        
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
        
        if let thumbnail = movie.selectedThumbnail {
            if thumbnail.isEmpty {
                thumbnailImageView.image = UIImage(named: "noimage")
                thumbnailImageView.contentMode = .scaleAspectFit
            }
        }
        
        createViews()
        setConstraints()
    }
    
    private func createViews() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(directorLabel)
        contentView.addSubview(actorLabel)
        contentView.addSubview(ratingStackView)
        ratingStackView.addArrangedSubview(ratingLabel)
        ratingStackView.addArrangedSubview(starRatingView)
    }
    
    private func setConstraints() {
        let thumbnailWidth: CGFloat = 120 // 이미지의 고정된 너비
        let thumbnailHeight: CGFloat = 160 // 이미지의 고정된 높이
        let margin: CGFloat = 10
        
        thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        thumbnailImageView.widthAnchor.constraint(equalToConstant: thumbnailWidth).isActive = true
        thumbnailImageView.heightAnchor.constraint(equalToConstant: thumbnailHeight).isActive = true
        thumbnailImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: margin).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin).isActive = true
        
        directorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        directorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        directorLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        
        actorLabel.topAnchor.constraint(equalTo: directorLabel.bottomAnchor, constant: 5).isActive = true
        actorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        actorLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true

        ratingStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        ratingStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin).isActive = true
    }
    
    // 초기화 메서드
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
