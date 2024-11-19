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
                1: ["fire_dragon_111_1", "fire_dragon_111_2", "fire_dragon_111_3", "fire_dragon_111_4"],
                2: ["fire_dragon_112_1", "fire_dragon_112_2", "fire_dragon_112_3", "fire_dragon_112_4"],
                3: ["fire_dragon_113_1", "fire_dragon_113_2", "fire_dragon_113_3", "fire_dragon_113_4"]
            ],
            2: [ // 크리쳐 2 (번개)
                1: ["thunder_121_1", "thunder_121_2", "thunder_121_3", "thunder_121_4"],
                2: ["thunder_122_1", "thunder_122_2", "thunder_122_3", "thunder_122_4"],
                3: ["thunder_123_1", "thunder_123_2", "thunder_123_3", "thunder_123_4"]
            ],
            3: [ // 크리쳐 3 (풀)
                1: ["sander_131_1", "sander_131_2", "sander_131_3", "sander_131_4"],
                2: ["sander_132_1", "sander_132_2", "sander_132_3", "sander_132_4"],
                3: ["sander_133_1", "sander_133_2", "sander_133_3", "sander_133_4"]
            ]
        ],
        
        2: [ // 언데드
            1: [ // 고스트
                1: ["ghost211_1", "ghost211_2", "ghost211_3", "ghost211_4"],
                2: ["ghost212_1", "ghost212_2", "ghost212_3", "ghost212_4"],
                3: ["ghost213_1", "ghost213_2", "ghost213_3", "ghost213_4"]
            ],
            2: [ // 리퍼
                1: ["repear221_1", "repear221_2", "repear221_3", "repear221_4"],
                2: ["repear222_1", "repear222_2", "repear222_3", "repear222_4"],
                3: ["repear223_1", "repear223_2", "repear223_3", "repear223_4"]
            ],
            3: [ // 뱀파이어
                1: ["vampire231_1", "vampire231_2", "vampire231_3", "vampire231_4"],
                2: ["vampire232_1", "vampire232_2", "vampire232_3", "vampire232_4"],
                3: ["vampire233_1", "vampire233_2", "vampire233_3", "vampire233_4"]
            ]
        ],
        
        3: [ // 인간
            1: [ // 탐험가
                1: ["explorer_1_1", "explorer_1_2", "explorer_1_3", "explorer_1_4"],
                2: ["explorer_2_1", "explorer_2_2", "explorer_2_3", "explorer_2_4"],
                3: ["explorer_3_1", "explorer_3_2", "explorer_3_3", "explorer_3_4"]
            ],
            2: [ // 전사
                1: ["warrior_1_1", "warrior_1_2", "warrior_1_3", "warrior_1_4"],
                2: ["warrior_2_1", "warrior_2_2", "warrior_2_3", "warrior_2_4"],
                3: ["warrior_3_1", "warrior_3_2", "warrior_3_3", "warrior_3_4"]
            ],
            3: [ // 마법사
                1: ["wizard_1_1", "wizard_1_2", "wizard_1_3", "wizard_1_4"],
                2: ["wizard_2_1", "wizard_2_2", "wizard_2_3", "wizard_2_4"],
                3: ["wizard_3_1", "wizard_3_2", "wizard_3_3", "wizard_3_4"]
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

