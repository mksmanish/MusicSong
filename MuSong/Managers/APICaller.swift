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
    
    // MARK: - Category
    public func getCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
            createRequest(
                with: URL(string: Constant.baseAPIURL + "/browse/categories?limit=50"),
                type: .GET
            ) { request in
                let task = URLSession.shared.dataTask(with: request) { data, _, error in
                    guard let data = data, error == nil else{
                        completion(.failure(APIError.failedToGetData))
                        return
                    }

                    do {
                        let result = try JSONDecoder().decode(AllCategoriesResponse.self,
                                                              from: data)
                        completion(.success(result.categories.items))
                    }
                    catch {
                        completion(.failure(error))
                    }
                }
                task.resume()
            }
        }
    // MARK: - CategoryPlaylists
    public func getCategoryPlaylists(category: Category, completion: @escaping (Result<[Playlist], Error>) -> Void) {
           createRequest(
               with: URL(string: Constant.baseAPIURL + "/browse/categories/\(category.id)/playlists?limit=50"),
               type: .GET
           ) { request in
               let task = URLSession.shared.dataTask(with: request) { data, _, error in
                   guard let data = data, error == nil else{
                       completion(.failure(APIError.failedToGetData))
                       return
                   }

                   do {
                       let result = try JSONDecoder().decode(CategoryPlaylistsResponse.self, from: data)
                       let playlists = result.playlists.items
                       completion(.success(playlists))
                   }
                   catch {
                       completion(.failure(error))
                   }
               }
               task.resume()
           }
       }

    
     // MARK: - Albums
    
    static func getAlbum (for album : Album,completion:@escaping(Result<AlbumDetailResponse,Error>) -> Void) {
        createRequest(with: URL(string: Constant.baseAPIURL + "/albums/" + album.id), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, dataresponse, error in
                guard let data = data ,error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(AlbumDetailResponse.self, from: data)
                  //  print(result)
                    completion(.success(result))
                    
                }catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    
     // MARK: - Playlits
    
    static func getPlaylist (for playlist : Playlist,completion:@escaping(Result<PlaylistDetailsResponse,Error>) -> Void) {
        createRequest(with: URL(string: Constant.baseAPIURL + "/playlists/" + playlist.id), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, dataresponse, error in
                guard let data = data ,error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(PlaylistDetailsResponse.self, from: data)
                    print(result)
                   completion(.success(result))
                    
                }catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    
    
    // MARK: - Profile API
    public func getCurrentUserProfile(completion:@escaping (Result<UserProfile,Error>) -> Void) {
        createRequest(with: URL(string: Constant.baseAPIURL + "/me"), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, dataresponse, error in
                guard let data = data ,error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                 //   print(result)
                    completion(.success(result))
                    
                }catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - new Release
    public func getNewReleases(completion:@escaping((Result<NewReleaseResponse,Error>)) -> Void) {
        createRequest(with: URL(string: Constant.baseAPIURL + "/browse/new-releases?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data ,error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(NewReleaseResponse.self, from: data)
               //     print(result)
                    completion(.success(result))
                    
                }catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - featured playlist
    public func getFeaturedPlaylists(completion:@escaping((Result<FeaturedPlaylistsResponse,Error>)) -> Void) {
        createRequest(with: URL(string: Constant.baseAPIURL + "/browse/featured-playlists?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, dataresponse, error in
                guard let data = data ,error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: data)
                  //  print(result)
                    completion(.success(result))
                    
                }catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - recommendation API
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
    
    // MARK: - recommendation Genres
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
    // MARK: - Search
    public func search(with query: String, completion: @escaping (Result<[SearchResult], Error>) -> Void) {
        createRequest(
            with: URL(string: Constant.baseAPIURL+"/search?limit=10&type=album,artist,playlist,track&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"),
            type: .GET
        ) { request in
            print(request.url?.absoluteString ?? "none")
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }

                do {
                    let result = try JSONDecoder().decode(SearchResultsResponse.self, from: data)

                    var searchResults: [SearchResult] = []
                    searchResults.append(contentsOf: result.tracks.items.compactMap({ .track(model: $0) }))
                    searchResults.append(contentsOf: result.albums.items.compactMap({ .album(model: $0) }))
                    searchResults.append(contentsOf: result.artists.items.compactMap({ .artist(model: $0) }))
                    searchResults.append(contentsOf: result.playlists.items.compactMap({ .playlist(model: $0) }))

                    completion(.success(searchResults))
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - current playlist
    public func getCurrentUserPlaylists(completion: @escaping (Result<[Playlist], Error>) -> Void) {
           createRequest(
               with: URL(string: Constant.baseAPIURL + "/me/playlists/?limit=50"),
               type: .GET
           ) { request in
               let task = URLSession.shared.dataTask(with: request) { data, _, error in
                   guard let data = data, error == nil else {
                       completion(.failure(APIError.failedToGetData))
                       return
                   }

                   do {
                       let result = try JSONDecoder().decode(LibraryPlaylistsResponse.self, from: data)
                       completion(.success(result.items))
                   }
                   catch {
                       print(error)
                       completion(.failure(error))
                   }
               }
               task.resume()
           }
       }
    
    // MARK: - current album
    public func getCurrentUserAlbums(completion: @escaping (Result<[Album], Error>) -> Void) {
           createRequest(
               with: URL(string: Constant.baseAPIURL + "/me/albums"),
               type: .GET
           ) { request in
               let task = URLSession.shared.dataTask(with: request) { data, _, error in
                   guard let data = data, error == nil else {
                       completion(.failure(APIError.failedToGetData))
                       return
                   }

                   do {
                       let result = try JSONDecoder().decode(LibraryAlbumsResponse.self, from: data)
                       completion(.success(result.items.compactMap({ $0.album })))
                   }
                   catch {
                       completion(.failure(error))
                   }
               }
               task.resume()
           }
       }
    
    // MARK: - create playlist

    public func createPlaylist(with name: String, completion: @escaping (Bool) -> Void) {
            getCurrentUserProfile { [weak self] result in
                switch result {
                case .success(let profile):
                    let urlString = Constant.baseAPIURL + "/users/\(profile.id)/playlists"
                    print(urlString)
                    
                    createRequest(with: URL(string: urlString), type: .POST) { baseRequest in
                        var request = baseRequest
                        let json = [
                            "name": name
                        ]
                        request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
                        print("Starting creation...")
                        let task = URLSession.shared.dataTask(with: request) { data, _, error in
                            guard let data = data, error == nil else {
                                completion(false)
                                return
                            }

                            do {
                                let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                                if let response = result as? [String: Any], response["id"] as? String != nil {
                                    completion(true)
                                }
                                else {
                                    completion(false)
                                }
                            }
                            catch {
                                print(error.localizedDescription)
                                completion(false)
                            }
                        }
                        task.resume()
                    }

                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    
    
    // MARK: - add track to playlist
    
    public func addTrackToPlaylist(
            track: AudioTrack,
            playlist: Playlist,
            completion: @escaping (Bool) -> Void
        ) {
            createRequest(
                with: URL(string: Constant.baseAPIURL + "/playlists/\(playlist.id)/tracks"),
                type: .POST
            ) { baseRequest in
                var request = baseRequest
                let json = [
                    "uris": [
                        "spotify:track:\(track.id)"
                    ]
                ]
                print(json)
                request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                print("Adding...")
                let task = URLSession.shared.dataTask(with: request) { data, _, error in
                    guard let data = data, error == nil else{
                        completion(false)
                        return
                    }

                    do {
                        let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                            print(result)
                        if let response = result as? [String: Any],
                           response["snapshot_id"] as? String != nil {
                            completion(true)
                        }
                        else {
                            completion(false)
                        }
                    }
                    catch {
                        completion(false)
                    }
                }
                task.resume()
            }
        }
    
    // MARK: - remove track from playlist

        public func removeTrackFromPlaylist(
            track: AudioTrack,
            playlist: Playlist,
            completion: @escaping (Bool) -> Void
        ) {
            createRequest(
                with: URL(string: Constant.baseAPIURL + "/playlists/\(playlist.id)/tracks"),
                type: .DELETE
            ) { baseRequest in
                var request = baseRequest
                let json: [String: Any] = [
                    "tracks": [
                        [
                            "uri": "spotify:track:\(track.id)"
                        ]
                    ]
                ]
                request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                let task = URLSession.shared.dataTask(with: request) { data, _, error in
                    guard let data = data, error == nil else{
                        completion(false)
                        return
                    }

                    do {
                        let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                        if let response = result as? [String: Any],
                           response["snapshot_id"] as? String != nil {
                            completion(true)
                        }
                        else {
                            completion(false)
                        }
                    }
                    catch {
                        completion(false)
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
        case DELETE
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
    
    

