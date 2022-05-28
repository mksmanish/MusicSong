//
//  NewReleaseResponse.swift
//  MuSong
//
//  Created by Tradesocio on 28/05/22.
//

import Foundation

struct NewReleaseResponse:Codable {
    let albums: AlbumsResponse
    
    
}
struct AlbumsResponse:Codable {
    let items: [Album]
}

struct Album : Codable {
    let album_type:String
    let available_markets:[String]
    let id: String
    let images:[APIImage]
    let name:String
    let release_date :String
    let total_tracks:Int
    let artists:[Artist]
    
}


