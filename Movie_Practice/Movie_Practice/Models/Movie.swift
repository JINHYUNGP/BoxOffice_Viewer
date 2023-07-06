//
//  Movie.swift
//  Movie_Practice
//
//  Created by 박진형 on 2023/05/10.
//

import Foundation
import CoreData

struct Movie {
    var title: String = ""
    var director: String = ""
    var actor: String = ""
    var rating: Double = 0.0
    var thumbnailImage: String = ""
    var description: String = ""
    var review: String = ""
    var rank: Int = 0
    var movieCd: String = ""
    var selectedThumbnail: String? {
        let thumbnailLinks = thumbnailImage.components(separatedBy: "|")
        return thumbnailLinks[0]
    }
}

extension Movie {
    init(dailyBoxOffice: DailyBoxOfficeList) {
        self.title = dailyBoxOffice.movieNm
        self.rank = Int(dailyBoxOffice.rank) ?? 0
        self.movieCd = dailyBoxOffice.movieCd
    }
}

class MovieManager {
    static let shared = MovieManager()
    let key: String = "d67766593b4bd434fae7f1e206695048"
    let kmdbKey: String = "LOV5FT0SFK72YRUOP87J"
    
    let targetDt: String = {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: yesterday ?? Date())
    }()
    var movies: [DailyBoxOfficeList] = []
    var currentStartCount: Int = 0
    var maxCount: Int = 0
    private init() {
        
    }
    func setCurrentStartCountZero() {
        self.currentStartCount = 0
    }
    func fetchMovies(completion: @escaping ([Movie]) -> Void) {
        fetchBoxOfficeData { result in
            switch result {
            case .success(let boxOfficeResult):
                var resultMovies: [Movie] = []
                let movies = boxOfficeResult.map { dailyBoxOffice in
                    let movie = Movie(dailyBoxOffice: dailyBoxOffice)
                    return movie
                }
                // 영화 배열을 돌면서 fetchKMDBData 함수를 호출하여 thumbnail 채우기
                let dispatchGroup = DispatchGroup()
                
                for index in movies.indices {
                    dispatchGroup.enter()
                    let movie = movies[index]
                    self.fetchKMDBData(with: movie.title) { fetchedMovie in
                        if let fetchedMovie = fetchedMovie {
                            var updatedMovie = fetchedMovie
                            updatedMovie.rank = movie.rank
                            updatedMovie.movieCd = movie.movieCd
                            resultMovies.append(updatedMovie)
                        }
                        dispatchGroup.leave()
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    // 모든 fetchKMDBData 호출이 완료된 후에 completion을 호출하여 movies 배열 반환
                    completion(resultMovies)
                }
                
            case .failure(let error):
                print("Error fetching movie data: \(error)")
                completion([])
            }
        }
    }
    
    func fetchBoxOfficeData(completion: @escaping (Result<[DailyBoxOfficeList], Error>) -> Void) {
        let urlString = "http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(key)&targetDt=\(targetDt)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data returned", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let boxOfficeResult = try JSONDecoder().decode(BoxOffice.self, from: data).boxOfficeResult
                completion(.success(boxOfficeResult.dailyBoxOfficeList))
                self.movies = boxOfficeResult.dailyBoxOfficeList
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchKMDBData(with movieTitle: String, completion: @escaping (Movie?) -> Void) {
        // API 엔드포인트 URL
        guard let encodedTitle = movieTitle.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "http://api.koreafilm.or.kr/openapi-data2/wisenut/search_api/search_json2.jsp?collection=kmdb_new2&detail=Y&title=\(encodedTitle)&ServiceKey=\(kmdbKey)") else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            // 에러 처리
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // 응답 검사
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response")
                completion(nil)
                return
            }
            
            // 데이터 검사
            guard let jsonData = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                // JSON 데이터 파싱
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let kmdb = try decoder.decode(KMDB.self, from: jsonData)

                guard let movieData = kmdb.data[0].result.sorted(by:{ $0.ratings.rating.last?.releaseDate ?? "" > $1.ratings.rating.last?.releaseDate ?? "" } ).first else {
                    print("No movie data found")
                    completion(nil)
                    return
                }
                
                var movie = Movie()
                movie.title = movieTitle
                
                for movieActor in movieData.actors.actor {
                    movie.actor += ", " + movieActor.actorNm
                }
                
                for movieDirector in movieData.directors.director {
                    movie.director += ", " + movieDirector.directorNm
                }
                
                for moviePlot in movieData.plots.plot {
                    movie.description += moviePlot.plotText
                }
                
                movie.rating = Double(movieData.ratings.rating[0].ratingGrade) ?? 0.0
                movie.thumbnailImage = movieData.posters
                // 데이터를 받은 후에 UI 업데이트를 수행
                DispatchQueue.main.async {
                    completion(movie)
                }
                
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }
        
        // 데이터 가져오기 시작
        task.resume()
    }
    
    func fetchAllMovies(with movieTitle: String, startCount: Int? = nil, completion: @escaping ([Movie]?) -> Void) {
        // API 엔드포인트 URL
        guard let encodedTitle = movieTitle.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let url = createURL(with: encodedTitle, startCount: startCount, apiKey: kmdbKey) else {
                print("Invalid URL")
                completion(nil)
                return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            // 에러 처리
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // 응답 검사
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response")
                completion(nil)
                return
            }
            
            // 데이터 검사
            guard let jsonData = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                // JSON 데이터 파싱
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let kmdb = try decoder.decode(KMDB.self, from: jsonData)
    
                var movies: [Movie] = []
                let totalCount = kmdb.totalCount
                if startCount ?? 0 >= totalCount {
                    completion(nil)
                } else {
                    self.maxCount = totalCount
                }

                for movieData in kmdb.data.first?.result ?? [] {
                    
                    var movie = Movie()
                    let title = movieData.title
                    let pattern = " !HS | !HE "
                    
                    var cleanedTitle = title.replacingOccurrences(of: pattern, with: "", options: .regularExpression)
                    if let firstNonWhitespaceIndex = cleanedTitle.firstIndex(where: { !$0.isWhitespace }) {
                        cleanedTitle = String(cleanedTitle[firstNonWhitespaceIndex...])
                    }
                    
                    movie.title = cleanedTitle
                    
                    for movieActor in movieData.actors.actor {
                        movie.actor += ", " + movieActor.actorNm
                    }
                    
                    for movieDirector in movieData.directors.director {
                        movie.director += ", " + movieDirector.directorNm
                    }
                    
                    for moviePlot in movieData.plots.plot {
                        movie.description += moviePlot.plotText
                    }
                    print(movie.description)
                    
                    movie.rating = Double(movieData.ratings.rating[0].ratingGrade) ?? 0.0
                    movie.thumbnailImage = movieData.posters
                    
                    movies.append(movie)
                }
                
                // 데이터를 받은 후에 UI 업데이트를 수행
                DispatchQueue.main.async {
                    completion(movies)
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }
        
        // 데이터 가져오기 시작
        task.resume()
    }
    
    private func createURL(with encodedTitle: String, startCount: Int? = nil, apiKey: String) -> URL? {
        var urlString = "http://api.koreafilm.or.kr/openapi-data2/wisenut/search_api/search_json2.jsp?collection=kmdb_new2&detail=Y&title=\(encodedTitle)&ServiceKey=\(apiKey)"
        
        if let startCount = startCount {
            urlString += "&startCount=\(startCount)"
        }
        
        return URL(string: urlString)
    }
    
}
