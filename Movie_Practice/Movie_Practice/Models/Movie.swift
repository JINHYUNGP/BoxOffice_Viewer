//
//  Movie.swift
//  Movie_Practice
//
//  Created by 박진형 on 2023/05/10.
//

import Foundation

struct Movie {
    var title: String = ""
    var director: String = ""
    var actor: String = ""
    var rating: Double = 0.0
    var thumbnailImage: String = ""
    var description: String = ""
    var review: String = ""
    var rank: Int = 0
    var selectedThumbnail: String? {
            let thumbnailLinks = thumbnailImage.components(separatedBy: "|")
            return thumbnailLinks[0]
        }
}
extension Movie {
    init(dailyBoxOffice: DailyBoxOfficeList) {
        self.title = dailyBoxOffice.movieNm
        self.rank = Int(dailyBoxOffice.rank) ?? 0
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
    var reviewedMovies: [Movie] = []
    
    
    private init() {
    }
    
    func fetchMovies(completion: @escaping ([Movie]) -> Void) {
        fetchBoxOfficeData { result in
            switch result {
            case .success(let boxOfficeResult):
                var resultMovies: [Movie] = []
                let movies = boxOfficeResult.map { dailyBoxOffice in
                    var movie = Movie(dailyBoxOffice: dailyBoxOffice)
                    return movie
                }
                // 영화 배열을 돌면서 fetchKMDBData 함수를 호출하여 thumbnail 채우기
                let dispatchGroup = DispatchGroup()
                
                for index in movies.indices {
                    dispatchGroup.enter()
                    var movie = movies[index]
                    self.fetchKMDBData(with: movie.title) { fetchedMovie in
                        if let fetchedMovie = fetchedMovie {
                            movie.thumbnailImage = fetchedMovie.thumbnailImage
                            resultMovies.append(movie)
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
                guard let movieData = kmdb.data.first?.result.first else {
                    print("No movie data found")
                    completion(nil)
                    return
                }
                
                var movie = Movie()
                movie.title = movieTitle
                for movieActor in movieData.actors.actor {
                    movie.actor += movieActor.actorNm
                }
                
                for movieDirector in movieData.directors.director {
                    movie.director += movieDirector.directorNm
                }
                
                for moviePlot in movieData.plots.plot {
                    movie.description += moviePlot.plotText
                }
                
                movie.rating = Double(movieData.ratings.rating[0].ratingGrade) ?? 0.0
                movie.thumbnailImage = movieData.posters
                
                // 데이터를 받은 후에 UI 업데이트를 수행
                DispatchQueue.main.async {
                    self.updateUI(with: kmdb)
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
    
    func fetchAllMovies(with movieTitle: String, completion: @escaping ([Movie]?) -> Void) {
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
                
                var movies: [Movie] = []
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
                        movie.actor += movieActor.actorNm
                    }
                    
                    for movieDirector in movieData.directors.director {
                        movie.director += movieDirector.directorNm
                    }
                    
                    for moviePlot in movieData.plots.plot {
                        movie.description += moviePlot.plotText
                    }
                    
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
    
    func updateUI(with kmdb: KMDB) {
        // kmdb 객체에서 필요한 데이터를 추출하여 UI를 업데이트하는 코드를 작성합니다.
        
//        // 예시로 데이터를 출력하는 코드
//        print("Query: \(kmdb.query)")
//        print("KMA Query: \(kmdb.kmaQuery)")
//        print("Total Count: \(kmdb.totalCount)")
//
//        for datum in kmdb.data {
//            print("Coll Name: \(datum.collName)")
//            print("Total Count: \(datum.totalCount)")
//            print("Count: \(datum.count)")
//
//            for result in datum.result {
//                print("Doc ID: \(result.docid)")
//                print("Movie ID: \(result.movieID)")
//                // 필요한 데이터를 추가로 출력하거나, 데이터를 활용하여 UI를 업데이트하는 코드를 작성합니다.
//            }
//        }
        
        // UI 업데이트 코드 작성
        // 예시로는 콘솔에 데이터를 출력했지만, 실제로는 레이블, 이미지뷰, 테이블뷰 등의 UI 컴포넌트를 업데이트해야 합니다.
    }
    
}
