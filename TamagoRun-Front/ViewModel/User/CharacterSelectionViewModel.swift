//
//  CharacterSelectionViewModel.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/8/24.
//

import Foundation

class CharacterSelectionViewModel: ObservableObject {
    @Published var selectedRace: String?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func selectSpecies(completion: @escaping (Bool) -> Void) {
        guard let selectedRace = selectedRace else {
            errorMessage = "종족을 선택해주세요"
            completion(false)
            return
        }
        
        let speciesNumber: Int
        switch selectedRace {
        case "Creature": speciesNumber = 1
        case "Undead": speciesNumber = 2
        case "Animal": speciesNumber = 3
        default:
            errorMessage = "올바르지 않은 종족입니다"
            completion(false)
            return
        }
        
        isLoading = true
        
        UserService.shared.selectSpecies(species: speciesNumber) { [weak self] success in
            DispatchQueue.main.async {
                self?.isLoading = false
                if !success {
                    self?.errorMessage = "종족 선택에 실패했습니다"
                }
                completion(success)
            }
        }
    }
}
