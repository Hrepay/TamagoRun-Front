//
//  MainPageDto.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 10/1/24.
//

import Foundation

struct MainPageDto: Codable {
    let loginId: String
    let experience: Int
    let species: Int
    let kindOfCharacter: Int
    let evolutionLevel: Int
}
