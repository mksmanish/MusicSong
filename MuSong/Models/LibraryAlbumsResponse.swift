//
//  File.swift
//  MuSong
//
//  Created by Tradesocio on 29/05/22.
//

import Foundation

struct LibraryAlbumsResponse: Codable {
    let items: [SavedAlbum]
}

struct SavedAlbum: Codable {
    let added_at: String
    let album: Album
}
