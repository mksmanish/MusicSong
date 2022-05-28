//
//  AudioTrack.swift
//  MuSong
//
//  Created by Tradesocio on 26/05/22.
//

import Foundation


struct AudioTrack: Codable {
    var album: Album?
    let artists: [Artist]
    let available_markets: [String]
    let disc_number: Int
    let duration_ms: Int
    let explicit: Bool
    let external_urls: [String: String]
    let id: String
    let name: String
    let preview_url: String?
}
