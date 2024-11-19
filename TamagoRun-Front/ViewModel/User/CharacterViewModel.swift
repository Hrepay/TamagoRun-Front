//
//  CharacterViewModel.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 9/30/24.
//

import Foundation

class CharacterViewModel: ObservableObject {
    
    // 메인 캐릭터 띄울 때 필요한 프로퍼티
    @Published var currentImageIndex: Int = 0
    @Published var characterImages: [String] = []
    @Published var loginId: String = ""
    @Published var experience: Int = 0
    @Published var species: Int = 0
    @Published var kindOfCharacter: Int = 0
    @Published var evolutionLevel: Int = 0
    
    // 캐릭터가 000일때
    @Published var shouldShowCharacterSelection: Bool = false
    
    // 캐릭터 진화 시 필요한 프로퍼티
    @Published var isEvolutionAnimating = false
    @Published var currentEggIndex = 1
    @Published var hasCompletedEggAnimation = false
    @Published var evolutionCompleted = false
    @Published var newCharacterImages: [String] = []
    
    private var eggAnimationTimer: Timer?
    private var evolutionFlashTimer: Timer?
    
    // 캐릭터 움직임 타이머 설정 프로퍼티
    private var animationTimer: Timer?
    
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
    
    // 캐릭터 받기
    func fetchCharacterImages(species: Int, kindOfCharacter: Int, evolutionLevel: Int) {
        let characterCode = species * 100 + kindOfCharacter * 10 + evolutionLevel
        print("🔍 Fetching images for character code: \(characterCode)")
        let images = CharacterImages.getCharacterImages(characterCode: characterCode)
        print("📦 Retrieved images: \(images)")
        self.characterImages = images
        print("✅ Current images count: \(self.characterImages.count)")
        self.currentImageIndex = 0  // 명시적으로 초기화
    }
    
    // 캐릭터 이미지 업데이트
    func updateCharacterInfo(species: Int, kindOfCharacter: Int, evolutionLevel: Int) {
        fetchCharacterImages(species: species, kindOfCharacter: kindOfCharacter, evolutionLevel: evolutionLevel)
    }
    
    // 타이머를 통해 이미지를 업데이트하는 메서드
    func startImageAnimation() {
        guard !characterImages.isEmpty else { return }
        
        animationTimer?.invalidate()
       
        // 새로운 타이머 생성 및 저장
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.currentImageIndex = (self.currentImageIndex + 1) % self.characterImages.count
        }
    }
    
    // 종족 선택 및 캐릭터 불러오기
    func fetchCharacterInfo() {
        UserService.shared.fetchCharacterInfo { [weak self] loginId, experience, species, kindOfCharacter, evolutionLevel in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.loginId = loginId
                self.experience = experience
                self.species = species
                self.kindOfCharacter = kindOfCharacter
                self.evolutionLevel = evolutionLevel
                
                // 000 체크하여 캐릭터 선택 필요 여부 설정
                self.shouldShowCharacterSelection =
                    species == 0 && kindOfCharacter == 0 && evolutionLevel == 0
                
                // 캐릭터 이미지를 업데이트
                self.updateCharacterInfo(species: species, kindOfCharacter: kindOfCharacter, evolutionLevel: evolutionLevel)
            }
        }
    }
    
    // MARK: - 진화 관련
    // 캐릭터가 알 상태인지 확인
        var isEggState: Bool {
            let characterCode = species * 100 + kindOfCharacter * 10 + evolutionLevel
            return characterCode == 100 || characterCode == 200 || characterCode == 300
        }
        
    // 알 부화 애니메이션
    func startHatchingAnimation(completion: @escaping () -> Void) {
        eggAnimationTimer?.invalidate()
        currentEggIndex = 1
        hasCompletedEggAnimation = false
        evolutionCompleted = false
        
        // hatchEgg_1 부터 hatchEgg_15 까지 순차적으로 변경
        eggAnimationTimer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            if self.currentEggIndex < 15 {
                self.currentEggIndex += 1
            } else {
                timer.invalidate()
                self.evolveFromEgg { success in
                    if success {
                        self.hasCompletedEggAnimation = true
                        self.evolutionCompleted = true
                        completion()
                    }
                }
            }
        }
    }
    
    // 일반 진화 깜빡임 애니메이션
    func startEvolutionAnimation(completion: @escaping () -> Void) {
        evolutionFlashTimer?.invalidate()
        isEvolutionAnimating = true
        evolutionCompleted = false
        
        var flashCount = 0
        let maxFlashes = 6 // 3번 깜빡임 (켜짐/꺼짐 각각 1회)
        
        evolutionFlashTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            if flashCount < maxFlashes {
                self.isEvolutionAnimating.toggle()
                flashCount += 1
            } else {
                timer.invalidate()
                self.isEvolutionAnimating = false
                
                // 깜빡임 완료 후 진화 요청
                self.evolveCharacter { success in
                    if success {
                        self.evolutionCompleted = true
                        completion()
                    }
                }
            }
        }
    }
    
    // 알에서의 첫 진화
    private func evolveFromEgg(completion: @escaping (Bool) -> Void) {
        CharacterService.shared.selectCharacter { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let evolutionDto):
                    // 새 캐릭터 정보 저장
                    self.species = evolutionDto.species
                    self.kindOfCharacter = evolutionDto.kindOfCharacter
                    self.evolutionLevel = evolutionDto.evolutionLevel
                    self.experience = 0
                    
                    // 새 캐릭터 이미지 가져오기
                    self.fetchCharacterImages(
                        species: evolutionDto.species,
                        kindOfCharacter: evolutionDto.kindOfCharacter,
                        evolutionLevel: evolutionDto.evolutionLevel
                    )
                    completion(true)
                    
                case .failure(let error):
                    print("Evolution from egg failed: \(error)")
                    completion(false)
                }
            }
        }
    }
    
    // 일반 캐릭터 진화
    private func evolveCharacter(completion: @escaping (Bool) -> Void) {
        CharacterService.shared.evolutionCharacter { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let evolutionDto):
                    // 새 캐릭터 정보 저장
                    self.species = evolutionDto.species
                    self.kindOfCharacter = evolutionDto.kindOfCharacter
                    self.evolutionLevel = evolutionDto.evolutionLevel
                    
                    // 새 캐릭터 이미지 가져오기
                    self.fetchCharacterImages(
                        species: evolutionDto.species,
                        kindOfCharacter: evolutionDto.kindOfCharacter,
                        evolutionLevel: evolutionDto.evolutionLevel
                    )
                    completion(true)
                    
                case .failure(let error):
                    print("Evolution failed: \(error)")
                    completion(false)
                }
            }
        }
    }
    
    // 진화 조건 체크
    func checkEvolutionCondition() -> Bool {
        return experience >= maxExperience
    }
    
    // 리소스 정리
    func cleanup() {
        eggAnimationTimer?.invalidate()
        eggAnimationTimer = nil
        evolutionFlashTimer?.invalidate()
        evolutionFlashTimer = nil
    }
    
    deinit {
        cleanup()
        animationTimer?.invalidate()
    }
}
