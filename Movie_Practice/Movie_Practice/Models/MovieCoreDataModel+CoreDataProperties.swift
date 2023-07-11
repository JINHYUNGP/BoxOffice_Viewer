//
//  MovieCoreDataModel+CoreDataProperties.swift
//  Movie_Practice
//
//  Created by 박진형 on 2023/06/30.
//
//

import Foundation
import CoreData


extension MovieCoreDataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieCoreDataModel> {
        return NSFetchRequest<MovieCoreDataModel>(entityName: "MovieCoreDataModel")
    }

    @NSManaged public var actor: String?
    @NSManaged public var director: String?
    @NSManaged public var movieDescription: String?
    @NSManaged public var rank: Int32
    @NSManaged public var rating: Double
    @NSManaged public var review: String?
    @NSManaged public var thumbnailImage: String?
    @NSManaged public var title: String?
    @NSManaged public var movieCd: String?

}

extension MovieCoreDataModel : Identifiable {

}
