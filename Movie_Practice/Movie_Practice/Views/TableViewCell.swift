//
//  TableViewCell.swift
//  Movie_Practice
//
//  Created by 박진형 on 2023/05/14.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    // 영화 데이터를 표시하기 위한 뷰들
    let titleLabel = UILabel()
    let directorLabel = UILabel()
    let actorLabel = UILabel()
    let ratingLabel = UILabel()
    let thumbnailImageView = UIImageView()
    
    // 영화 데이터를 설정하는 메서드
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        
        var refinedActor: String {
            var tempActor = movie.actor
            if !tempActor.isEmpty {
                tempActor.removeFirst()
                tempActor.removeFirst()
            }
            else {
                return  ""
            }
            return tempActor
        }
        var refinedDirector: String {
            var tempDirector = movie.director
            if !tempDirector.isEmpty {
                tempDirector.removeFirst()
                tempDirector.removeFirst()
            }
            else {
                return  ""
            }
            return tempDirector
        }
        directorLabel.text = "감독: " + refinedDirector
        actorLabel.text = "배우: " + refinedActor
        ratingLabel.text = "평점: "
        
//        let starRatingView: StarRatingView = {
//            let initialRating: Float = Float(movie.rating)
//            let view = StarRatingView(frame: CGRect(x: 0, y: 0, width: 100, height: 5), initialRating: initialRating)
//            view.translatesAutoresizingMaskIntoConstraints = false
//            return view
//        }()
        
        // StarRatingView를 contentView에 추가
        contentView.addSubview(titleLabel)
        contentView.addSubview(directorLabel)
        contentView.addSubview(actorLabel)
        contentView.addSubview(ratingLabel)
        //contentView.addSubview(starRatingView)
        
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.lineBreakMode = .byTruncatingTail // 너비를 초과하는 경우 생략 부호로 표시
        titleLabel.numberOfLines = 1 // 단일 라인으로 표시
        directorLabel.font = UIFont.systemFont(ofSize: 16)
        actorLabel.font = UIFont.systemFont(ofSize: 16)
        ratingLabel.font = UIFont.systemFont(ofSize: 16)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        directorLabel.translatesAutoresizingMaskIntoConstraints = false
        actorLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        
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
                thumbnailImageView.image = UIImage(systemName: "film")
            }
        }
        let thumbnailWidth: CGFloat = 120 // 이미지의 고정된 너비
        let thumbnailHeight: CGFloat = 160 // 이미지의 고정된 높이

 //       thumbnailImageView.contentMode = .scaleAspectFill // 이미지를 프레임에 맞춰 채우기
//        thumbnailImageView.frame = CGRect(x: 0, y: 0, width: thumbnailWidth, height: thumbnailHeight)
        thumbnailImageView.clipsToBounds = true // 이미지를 프레임 내에서 자르기
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(thumbnailImageView)
        // 다른 뷰들의 제약 조건도 수정해야 합니다.
        let margin: CGFloat = 10

        // 다른 뷰들의 제약 조건 수정
        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: thumbnailWidth),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: thumbnailHeight),
            thumbnailImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: margin),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            directorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            directorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            directorLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            actorLabel.topAnchor.constraint(equalTo: directorLabel.bottomAnchor),
            actorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            actorLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            ratingLabel.topAnchor.constraint(equalTo: actorLabel.bottomAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            ratingLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

        ])

        // titleLabel의 너비 제약 조건 설정
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    // 초기화 메서드
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
