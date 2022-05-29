//
//  SearchResults.swift
//  MuSong
//
//  Created by Tradesocio on 29/05/22.
//


import Foundation

enum SearchResult {
    case artist(model: Artist)
    case album(model: Album)
    case track(model: AudioTrack)
    case playlist(model: Playlist)
}
