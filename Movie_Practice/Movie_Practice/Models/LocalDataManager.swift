//
//  LocalDataManager.swift
//  Movie_Practice
//
//  Created by 박진형 on 2023/06/27.
//

import Foundation
import CoreData

final class LocalDataManager {
    static let shared = LocalDataManager()
    var reviewedMovies: [Movie] {
        var convertedMovies: [Movie] = []
        let fetchRequest: NSFetchRequest<MovieCoreDataModel> = MovieCoreDataModel.fetchRequest()
        do {
            let movies = try context.fetch(fetchRequest)
            for movie in movies{
                var tempMovie = Movie()
                tempMovie.title = movie.title ?? ""
                tempMovie.director = movie.director ?? ""
                tempMovie.rank = Int(movie.rank)
                tempMovie.description = movie.movieDescription ?? ""
                tempMovie.rating = movie.rating
                tempMovie.review = movie.review ?? ""
                tempMovie.thumbnailImage = movie.thumbnailImage ?? ""
                tempMovie.movieCd = movie.movieCd ?? ""
                convertedMovies.append(tempMovie)
            }
            return convertedMovies
        } catch {
            print("데이터 가져오기 실패: \(error)")
            return []
        }
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.entityName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    lazy var context = persistentContainer.viewContext
    private let entityName = "MovieCoreDataModel"
    
    func saveMovieContext(with movie: Movie) {
        let fetchRequest: NSFetchRequest<MovieCoreDataModel> = MovieCoreDataModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "movieCd = %@", movie.movieCd)
        
        do {
            let movies = try context.fetch(fetchRequest)
            
            if let existingMovie = movies.first {
                // 이미 해당 영화가 존재하는 경우
                existingMovie.review = movie.review // 리뷰 업데이트
                existingMovie.rating = movie.rating
            } else {
                // 해당 영화가 존재하지 않는 경우 새로 생성
                let coreDataModel = MovieCoreDataModel(context: context)
                coreDataModel.title = movie.title
                coreDataModel.actor = movie.actor
                coreDataModel.movieDescription = movie.description
                coreDataModel.rank = Int32(movie.rank)
                coreDataModel.rating = movie.rating
                coreDataModel.review = movie.review
                coreDataModel.thumbnailImage = movie.thumbnailImage
                coreDataModel.director = movie.director
                coreDataModel.movieCd = movie.movieCd
            }
            
            try context.save()
            print("영화가 CoreData에 저장되었습니다.")
        } catch {
            print("데이터 저장 실패: \(error)")
        }
    }
    
    func deleteData(with movieCd: String) {
        let fetchRequest: NSFetchRequest<MovieCoreDataModel> = MovieCoreDataModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "movieCd = %@", movieCd)
        print(movieCd)
        do {
            let movies = try context.fetch(fetchRequest)
            print(movies)
            for movie in movies {
                context.delete(movie)
            }
            try context.save() // 변경 내용을 저장합니다.
            print("데이터가 삭제되었습니다.")
        } catch {
            print("데이터 삭제 실패: \(error)")
        }
    }
}
