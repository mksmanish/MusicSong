//
//  Settings.swift
//  MuSong
//
//  Created by Tradesocio on 28/05/22.
//

import Foundation
struct Section{
    let title :String
    let options:[Option]
}

struct Option {
    let title :String
    let handler: () -> Void
}
