//
//  UserProfile.swift
//  MuSong
//
//  Created by Tradesocio on 26/05/22.
//

import Foundation
import UIKit

struct UserProfile : Codable{
    let country:String
    let display_name :String
    let email :String
    let explicit_content : [String:Bool]
    let external_urls : [String:String]
   // let folowers: [String:Codable?]
    let image:[APIImage]
    let id : String
    let product:String
    
}




