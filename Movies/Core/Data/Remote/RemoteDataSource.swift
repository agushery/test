//
//  RemoteDataSource.swift
//  Movies
//
//  Created by Agus Hery on 10/02/23.
//  Copyright © 2023 Agus Hery. All rights reserved.
//

import Foundation

protocol RemoteDataSource: AnyObject {
    func getPopularMovies(result: @escaping (Result<[MovieResponse], URLError>) -> Void)
    func getUpcomingMovies(result: @escaping (Result<[MovieResponse], URLError>) -> Void)
    func getDetailMovie(result: @escaping (Result<DetailMovieResponse, URLError>) -> Void, idMovie: String)
    func getVideoMovie(result: @escaping (Result<[Video], URLError>) -> Void, idMovie: String )
    func searchMovies(result: @escaping (Result<[MovieResponse], URLError>) -> Void, query: String)
}

final class RemoteDataSourceImpl: NSObject {
    
    private override init() { }
    
    static let sharedInstance: RemoteDataSource = RemoteDataSourceImpl()
    
}

extension RemoteDataSourceImpl: RemoteDataSource {
    
    func getPopularMovies(
        result: @escaping (Result<[MovieResponse], URLError>) -> Void
    ){
        guard let url = URL(string: EndPoints.Gets.popular.url) else {
            print("URL not found!")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                result(.failure(.addressUnReseachable(url)))
            } else if let data = data,
                      let response = response as? HTTPURLResponse,
                      response.statusCode == 200 {
                let decoder = JSONDecoder()
                do {
                    let movies = try decoder.decode(MoviesResponse.self, from: data).results
                    result(.success(movies))
                } catch {
                    result(.failure(.invalidResponse))
                }
            }
        }
        task.resume()
    }
    
    func getUpcomingMovies(
        result: @escaping (Result<[MovieResponse], URLError>) -> Void
    ){
        guard let url = URL(string: EndPoints.Gets.upcoming.url) else {
            print("URL not found!")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                result(.failure(.addressUnReseachable(url)))
            } else if let data = data,
                      let response = response as? HTTPURLResponse,
                      response.statusCode == 200 {
                let decoder = JSONDecoder()
                do {
                    let movies = try decoder.decode(MoviesResponse.self, from: data).results
                    result(.success(movies))
                } catch {
                    result(.failure(.invalidResponse))
                }
            }
        }
        task.resume()
    }
    
    func getDetailMovie(
        result: @escaping (Result<DetailMovieResponse, URLError>) -> Void,
        idMovie: String
    ) {
        guard let url = URL(string: EndPoints.Gets.detail(id: idMovie).url) else {
            print("URL not found!")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                result(.failure(.addressUnReseachable(url)))
            } else if let data = data,
                      let response = response as? HTTPURLResponse,
                      response.statusCode == 200 {
                let decoder = JSONDecoder()
                do {
                    let movies = try decoder.decode(DetailMovieResponse.self, from: data)
                    result(.success(movies))
                } catch {
                    result(.failure(.invalidResponse))
                }
            }
        }
        task.resume()
    }
    
    func getVideoMovie(
        result: @escaping (Result<[Video], URLError>) -> Void,
        idMovie: String
    ) {
        guard let url = URL(string: EndPoints.Gets.video(id: idMovie).url) else {
            print("URL not found!")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                result(.failure(.addressUnReseachable(url)))
            } else if let data = data,
                 let response = response as? HTTPURLResponse,
                 response.statusCode == 200 {
                let decoder = JSONDecoder()
                do {
                    let videos = try decoder.decode(VideoResponse.self, from: data).results
                    result(.success(videos))
                } catch {
                    result(.failure(.invalidResponse))
                }
            }
        }
        task.resume()
    }
    
    func searchMovies(
        result: @escaping (Result<[MovieResponse], URLError>) -> Void,
        query: String
    ) {
        let newQuery = query.replacingOccurrences(of: " ", with: "%20")
        guard let url = URL(string: EndPoints.Gets.search(query: newQuery).url) else {
            print("URL not found!")
            return
        }
        print(url)
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                result(.failure(.addressUnReseachable(url)))
            } else if let data = data,
                      let response = response as? HTTPURLResponse,
                      response.statusCode == 200 {
                let decoder = JSONDecoder()
                do {
                    let resultList = try decoder.decode(MoviesResponse.self, from: data).results
                    result(.success(resultList))
                } catch {
                    result(.failure(.invalidResponse))
                }
            }
        }
        task.resume()
    }
}
