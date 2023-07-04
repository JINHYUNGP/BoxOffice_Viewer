//
//  CustomModalViewController.swift
//  Movie_Practice
//
//  Created by 이주희 on 2023/06/23.
//
import UIKit

class CustomModalViewController: UIViewController {
    private let modalView = CustomModalView()
    var movie: Movie
    var didDismissModal: (() -> Void)?
    
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
        self.modalView.reviewButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupModalView()
        configure()
    }
    
    private func setupModalView() {

        let backgroundView = UIView(frame: view.bounds)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(backgroundView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        backgroundView.addGestureRecognizer(tapGesture)
        
        modalView.frame = CGRect(x: 50, y: 100, width: view.bounds.width - 50, height: 500)
        modalView.center = view.center
        modalView.backgroundColor = .white
        modalView.layer.cornerRadius = 20
        
        view.addSubview(modalView)
    }
    
    private func configure() {
        modalView.titleLabel.text = movie.title
        if let url = URL(string: movie.selectedThumbnail ?? "") {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        self.modalView.movieImage.image = image
                    }
                }
            }
        }
        modalView.summaryLabel.text = movie.description
    }
    
    @objc private func backgroundTapped() {
        dismiss(animated: false, completion: nil)
    }
    
    @objc private func buttonTapped() {
        let detailVC = DetailViewController(movie: self.movie)
        detailVC.modalPresentationStyle = .overFullScreen
        self.present(detailVC, animated: true, completion: nil)
    }
}
