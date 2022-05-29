//
//  Artist.swift
//  MuSong
//
//  Created by Tradesocio on 26/05/22.
//

import Foundation


struct Artist: Codable {
    let id: String
    let name: String
    let type: String
    let images: [APIImage]?
    let external_urls: [String: String]
}
