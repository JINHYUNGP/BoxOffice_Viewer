//
//  KMDB.swift
//  Movie_Practice
//
//  Created by 박진형 on 2023/05/21.
//

import Foundation


// MARK: - Result
struct KMDB: Codable {
    let totalCount: Int
    let data: [Datum]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "TotalCount"
        case data = "Data"
    }
}
// MARK: - Datum
struct Datum: Codable {

    let totalCount, count: Int
    let result: [KMDBResult]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "TotalCount"
        case count = "Count"
        case result = "Result"
    }
}

// MARK: - Result
struct KMDBResult: Codable {
    let title: String
    let directors: Directors
    let actors: Actors
    let plots: Plots
    let rating: String
    let ratings: Ratings
    let posters: String
    let stlls: String

    enum CodingKeys: String, CodingKey {
        case title = "title"
        case directors = "directors"
        case actors = "actors"
        case plots = "plots"
        case rating = "rating"
        case ratings = "ratings"
        case posters = "posters"
        case stlls = "stlls"

    }
}


// MARK: - Actors
struct Actors: Codable {
    let actor: [Actor]
}

// MARK: - Actor
struct Actor: Codable {
    let actorNm, actorEnNm, actorID: String
    
    enum CodingKeys: String, CodingKey {
        case actorNm, actorEnNm
        case actorID = "actorId"
    }
}

// MARK: - Directors
struct Directors: Codable {
    let director: [Director]
}

// MARK: - Director
struct Director: Codable {
    let directorNm, directorEnNm, directorID: String
    
    enum CodingKeys: String, CodingKey {
        case directorNm, directorEnNm
        case directorID = "directorId"
    }
}

// MARK: - Plots
struct Plots: Codable {
    let plot: [Plot]
}

// MARK: - Plot
struct Plot: Codable {
    let plotLang, plotText: String
}

// MARK: - Ratings
struct Ratings: Codable {
    let rating: [Rating]
}

// MARK: - Rating
struct Rating: Codable {
    let ratingMain, ratingDate, ratingNo, ratingGrade: String
    let releaseDate, runtime: String
}


