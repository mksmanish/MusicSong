//
//  APICaller.swift
//  MuSong
//
//  Created by Tradesocio on 26/05/22.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    private init() {}
    
    struct Constant {
        static let baseAPIURL = "https://api.spotify.com/v1"
    }
    enum APIError: Error {
        case failedToGetData
        
    }
    public func getCurrentUserProfile(completion:@escaping (Result<UserProfile,Error>) -> Void) {
        createRequest(with: URL(string: Constant.baseAPIURL + "/me"), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, dataresponse, error in
                guard let data = data ,error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    print(result)
                    completion(.success(result))
                    
                }catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getNewReleases(completion:@escaping((Result<NewReleaseResponse,Error>)) -> Void) {
        createRequest(with: URL(string: Constant.baseAPIURL + "/browse/new-releases?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data ,error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(NewReleaseResponse.self, from: data)
                    print(result)
                    completion(.success(result))
                    
                }catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getFeaturedPlaylists(completion:@escaping((Result<FeaturedPlaylistResponse,Error>)) -> Void) {
        createRequest(with: URL(string: Constant.baseAPIURL + "/browse/featured-playlists?limit=2"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, dataresponse, error in
                guard let data = data ,error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(FeaturedPlaylistResponse.self, from: data)
                    print(result)
                    completion(.success(result))
                    
                }catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getRecommendations(genres: Set<String>, completion: @escaping ((Result<RecommendationsResponse, Error>) -> Void)) {
            let seeds = genres.joined(separator: ",")
            createRequest(
                with: URL(string: Constant.baseAPIURL + "/recommendations?limit=40&seed_genres=\(seeds)"),
                type: .GET
            ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                    guard let data = data, error == nil else {
                        completion(.failure(APIError.failedToGetData))
                        return
                    }

                    do {
                        let result = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
                    //    print(result)
                        completion(.success(result))
                    }
                    catch {
                        completion(.failure(error))
                    }
                }
                task.resume()
            }
        }
    
    public func getrecommendationsGenres(completion:@escaping((Result<RecommendedGenresResponse,Error>)) -> Void) {
        createRequest(with: URL(string: Constant.baseAPIURL + "/recommendations/available-genre-seeds"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, dataresponse, error in
                guard let data = data ,error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
                 //   print(result)
                    completion(.success(result))
                    
                }catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
}
    
    
    // MARK: - Private
    
    enum HTTPMethod: String {
        case GET
        case POST
    }
    private func createRequest(with url:URL? ,
                               type:HTTPMethod,
                               completion:@escaping  (URLRequest) -> Void)  {
        AuthManager.shared.withValidToken { token in
            guard let apiURL = url else {return}
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
    
    

