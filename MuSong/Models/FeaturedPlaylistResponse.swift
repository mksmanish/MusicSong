//
//  FeaturedPlaylistResponse.swift
//  MuSong
//
//  Created by Tradesocio on 28/05/22.
//

import Foundation

struct FeaturedPlaylistResponse : Codable{
    
    let playlist: [PlaylistResponse]

}

struct PlaylistResponse:Codable {
    let items:[Playlist]
}

struct User: Codable {
    let display_name : String
    let external_urls : [String:String]
    let id : String
    
}
