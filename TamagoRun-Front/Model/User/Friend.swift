//
//  Friend.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/11/24.
//

import Foundation

struct Friend: Codable, Identifiable {
    let id = UUID()  // SwiftUI List를 위한 id
    let friendId: String
    let kindOfCharacter: Int
    let species: Int
    let evolutionLevel: Int
    
    enum CodingKeys: String, CodingKey {
        case friendId
        case kindOfCharacter
        case species
        case evolutionLevel
    }
}
