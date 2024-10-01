//
//  CharacterImages.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 9/30/24.
//

import Foundation

// CharacterImages.swift
struct CharacterImages {
    // 캐릭터 이미지를 저장하는 딕셔너리
    static let characterImagePaths: [Int: [Int: [Int: [String]]]] = [

        1: [ // 크리쳐 종족 100
            1: [ // 크리쳐 1 (불)
                1: ["fire_dragon_111_1", "fire_dragon_111_2", "fire_dragon_111_3", "fire_dragon_111_4"],
                2: ["fire_dragon_112_1", "fire_dragon_112_2", "fire_dragon_112_3", "fire_dragon_112_4"],
                3: ["fire_dragon_113_1", "fire_dragon_113_2", "fire_dragon_113_3", "fire_dragon_113_4"]
            ],
            2: [ // 크리쳐 2 (물)
                1: ["characters/creature/water/LV1/water_creature_1", "characters/creature/water/LV1/water_creature_2", "characters/creature/water/LV1/water_creature_3"],
                2: ["characters/creature/water/LV2/water_creature_1", "characters/creature/water/LV2/water_creature_2", "characters/creature/water/LV2/water_creature_3"],
                3: ["characters/creature/water/LV3/water_creature_1", "characters/creature/water/LV3/water_creature_2", "characters/creature/water/LV3/water_creature_3"]
            ],
            3: [ // 크리쳐 3
                1: ["characters/creature/earth/LV1/earth_creature_1", "characters/creature/earth/LV1/earth_creature_2", "characters/creature/earth/LV1/earth_creature_3"],
                2: ["characters/creature/earth/LV2/earth_creature_1", "characters/creature/earth/LV2/earth_creature_2", "characters/creature/earth/LV2/earth_creature_3"],
                3: ["characters/creature/earth/LV3/earth_creature_1", "characters/creature/earth/LV3/earth_creature_2", "characters/creature/earth/LV3/earth_creature_3"]
            ]
        ]
    ]
    
    // 캐릭터 코드를 기반으로 이미지 경로를 반환하는 함수
    static func getCharacterImages(characterCode: Int) -> [String] {
        // 알 상태일 경우 (반복되는 8장)
        if characterCode == 100 || characterCode == 200 || characterCode == 300 {
            return [
                "characters/egg/egg_01",
                "characters/egg/egg_02",
                "characters/egg/egg_03",
                "characters/egg/egg_04",
                "characters/egg/egg_05",
                "characters/egg/egg_06",
                "characters/egg/egg_07",
                "characters/egg/egg_08"
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

