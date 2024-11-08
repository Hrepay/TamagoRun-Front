//
//  CharacterImages.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 9/30/24.
//

import Foundation

struct CharacterImages {
    // 캐릭터 이미지를 저장하는 딕셔너리
    static let characterImagePaths: [Int: [Int: [Int: [String]]]] = [

        1: [ // 크리쳐 종족 100
            1: [ // 크리쳐 1 (불)
                1: ["Sun_duck", "Sun_duck", "Sun_duck", "Sun_duck"],
                2: ["fire_dragon_112_1", "fire_dragon_112_2", "fire_dragon_112_3", "fire_dragon_112_4"],
                3: ["thunder_121_1", "thunder_121_2", "thunder_121_3", "thunder_121_4"]
            ],
            2: [ // 크리쳐 2 (번개)
                1: ["fire_dragon_111_1", "fire_dragon_111_2", "fire_dragon_111_3", "fire_dragon_111_4"],
                2: ["fire_dragon_112_1", "fire_dragon_112_2", "fire_dragon_112_3", "fire_dragon_112_4"],
                3: ["fire_dragon_113_1", "fire_dragon_113_2", "fire_dragon_113_3", "fire_dragon_113_4"]
            ],
            3: [ // 크리쳐 3 (풀)
                1: ["fire_dragon_111_1", "fire_dragon_111_2", "fire_dragon_111_3", "fire_dragon_111_4"],
                2: ["fire_dragon_112_1", "fire_dragon_112_2", "fire_dragon_112_3", "fire_dragon_112_4"],
                3: ["fire_dragon_113_1", "fire_dragon_113_2", "fire_dragon_113_3", "fire_dragon_113_4"]
            ]
        ]
    ]
    
    // 캐릭터 코드를 기반으로 이미지 경로를 반환하는 함수
    static func getCharacterImages(characterCode: Int) -> [String] {
        // 알 상태일 경우 (반복되는 8장)
        if characterCode == 100 || characterCode == 200 || characterCode == 300 {
            return [
                "egg_01",
                "egg_02",
                "egg_03",
                "egg_04",
                "egg_05",
                "egg_06",
                "egg_07",
                "egg_08"
            ]
        }
        
        // 종족, 캐릭터, 진화 단계 분리
        let species = characterCode / 100
        let kindOfCharacter = (characterCode % 100) / 10
        let evolutionLevel = characterCode % 10
        
        // 해당하는 이미지 경로 반환
        return characterImagePaths[species]?[kindOfCharacter]?[evolutionLevel] ?? []
    }
}

