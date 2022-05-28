//
//  AuthManager.swift
//  MuSong
//
//  Created by Tradesocio on 26/05/22.
//

import Foundation
final class AuthManager {
    static let shared = AuthManager()
    private var refreshingToken = false
    struct Constants {
        static let clientID = "cf92c4fcb3fd4f1184d3235ff9f07220"
        static let ClientSecret = "043144ee44334dd5ad3ccca29a3d463e"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let redircetURI = "https://www.iosacademy.io/"
        static let scopes = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
    }
    private init() {}
    
    public var signInURL:URL? {
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redircetURI)&show_dialog=TRUE"
        return URL(string: string)
        
        
    }
    
    var isSignedIn:Bool {
        return accessToken != nil
    }
    
    private var accessToken:String?{
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String?{
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date? {
        return  UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken : Bool {
        guard let expirationDate = tokenExpirationDate else { return false}
        let currentDate = Date()
        let fiveMinutes:TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }
    
    public func exchangeCodeForToken(code:String,completion:@escaping(Bool) -> Void) {
        
        guard let url =  URL(string: Constants.tokenAPIURL) else {return}
        var componenets = URLComponents()
        componenets.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redircetURI)
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = componenets.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let basicToken = Constants.clientID+":"+Constants.ClientSecret
        
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            completion(false)
            return
        }
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task =  URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data,error == nil else{
                completion(false)
                return
            }
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result:result)
                completion(true)
               
            }catch{
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
        
    }
    
    private var onRefreshBlocks = [((String) -> Void)]()
    
    ///Supplies valid token to be used with API Calls
    public func withValidToken(completion:@escaping (String) -> Void) {
        guard !refreshingToken else {
            //Append the completion
            onRefreshBlocks.append(completion)
            return
        }
        if shouldRefreshToken {
            //refresh
            refreshIfNeeded {[weak self] success in
                
                if let token = self?.accessToken,success {
                    completion(token)
                }
            }
        }else if let token = accessToken {
            completion(token)
        }
    }
    public func refreshIfNeeded(completion:((Bool) -> Void)?) {
        
        guard !refreshingToken else {
            return
        }
        
        guard shouldRefreshToken else{
            completion?(true)
            return
        }
        guard let refreshToken = self.refreshToken else{
            return
        }
        // refresh the token
        guard let url =  URL(string: Constants.tokenAPIURL) else {return}
        refreshingToken = true
        
        var componenets = URLComponents()
        componenets.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = componenets.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let basicToken = Constants.clientID+":"+Constants.ClientSecret
        
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            completion?(false)
            return
        }
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task =  URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            self?.refreshingToken  = false
            guard let data = data,error == nil else{
                completion?(false)
                return
            }
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.onRefreshBlocks.forEach { $0(result.access_token)}
                self?.onRefreshBlocks.removeAll()
                self?.cacheToken(result:result)
                completion?(true)
               
            }catch{
                print(error.localizedDescription)
                completion?(false)
            }
        }
        task.resume()
        
    }
    private func cacheToken(result:AuthResponse) {
        UserDefaults.standard.set(result.access_token, forKey: "access_token")
        if let refreshToken = result.refresh_token {
            UserDefaults.standard.set(refreshToken, forKey: "refresh_token")
        }
        UserDefaults.standard.set(Date().addingTimeInterval(TimeInterval(result.access_token) ?? 0.0), forKey: "expirationDate")
    }
}
