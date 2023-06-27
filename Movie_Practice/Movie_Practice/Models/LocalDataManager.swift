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
        let context = persistentContainer.viewContext
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
    
    private let entityName = "MovieCoreDataModel"
    
    func saveMovieContext(with movie: Movie) {
        let context = persistentContainer.viewContext
        let coreDataModel = MovieCoreDataModel(context: context)
        coreDataModel.title = movie.title
        coreDataModel.actor = movie.actor
        coreDataModel.movieDescription = movie.description
        coreDataModel.rank = Int32(movie.rank)
        coreDataModel.rating = movie.rating
        coreDataModel.review = movie.review
        coreDataModel.thumbnailImage = movie.thumbnailImage
        coreDataModel.director = movie.director
        context.insert(coreDataModel)
        do {
            try context.save()
            print("영화가 CoreData에 저장되었습니다.")
        } catch {
            print("데이터 저장 실패: \(error)")
        }
    }
}
