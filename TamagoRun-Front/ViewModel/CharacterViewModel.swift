//
//  CharacterViewModel.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 9/30/24.
//

import Foundation

class CharacterViewModel: ObservableObject {
    @Published var currentImageIndex: Int = 0
    @Published var characterImages: [String] = []
    @Published var loginId: String = ""
    @Published var experience: Int = 0
    @Published var species: Int = 0
    @Published var kindOfCharacter: Int = 0
    @Published var evolutionLevel: Int = 0
    
    // maxExperience 프로퍼티 추가
    var maxExperience: Int {
        switch evolutionLevel {
        case 0:
            return 2000
        case 1:
            return 3000
        case 2:
            return 5000
        case 3:
            return 7000
        default:
            return 7000
        }
    }
    
    func updateCharacterInfo(species: Int, kindOfCharacter: Int, evolutionLevel: Int) {
        fetchCharacterImages(species: species, kindOfCharacter: kindOfCharacter, evolutionLevel: evolutionLevel)
    }
    
    // 기존 코드들
    func fetchCharacterImages(species: Int, kindOfCharacter: Int, evolutionLevel: Int) {
        let characterCode = species * 100 + kindOfCharacter * 10 + evolutionLevel
        characterImages = CharacterImages.getCharacterImages(characterCode: characterCode)
    }
    
    // 타이머를 통해 이미지를 업데이트하는 메서드
    func startImageAnimation() {
       guard !characterImages.isEmpty else { return }
       
       Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
           self.currentImageIndex = (self.currentImageIndex + 1) % self.characterImages.count
       }
   }
    
    func fetchCharacterInfo() {
        UserService.shared.fetchCharacterInfo { [weak self] loginId, experience, species, kindOfCharacter, evolutionLevel in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.loginId = loginId
                self.experience = experience
                self.species = species
                self.kindOfCharacter = kindOfCharacter
                self.evolutionLevel = evolutionLevel
                
                // 캐릭터 이미지를 업데이트
                self.updateCharacterInfo(species: species, kindOfCharacter: kindOfCharacter, evolutionLevel: evolutionLevel)
            }
        }
    }
}
