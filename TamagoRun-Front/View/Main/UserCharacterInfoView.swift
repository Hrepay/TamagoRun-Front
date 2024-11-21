//
//  UserCharacterInfoView.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/14/24.
//

import SwiftUI

struct UserCharacterInfoView: View {
    @ObservedObject var characterViewModel: CharacterViewModel
    @Binding var showEvolutionModal: Bool
    
    var body: some View {
        ZStack {  // VStack을 ZStack으로 변경
            // 메인 컨텐츠
            VStack {
                // 유저 닉네임
                Text(characterViewModel.loginId)
                    .font(.custom("DungGeunMo", size: 30))
                    .padding()
                
                // 캐릭터 경험치
                HStack {
                    Spacer()
                    Text("\(characterViewModel.experience) / \(characterViewModel.maxExperience)")
                        .font(.custom("DungGeunMo", size: 20))
                    Spacer()
                }
                
                // 경험치 바
                HStack(alignment: .center) {
                    Text("[")
                        .font(.custom("DungGeunMo", size: 24))
                    
                    ProgressView(value: Double(characterViewModel.experience),
                               total: Double(characterViewModel.maxExperience))
                        .progressViewStyle(LinearProgressViewStyle(tint: .black))
                        .frame(width: 200, height: 10)
                        .padding(.top, 5)
                    
                    Text("]")
                        .font(.custom("DungGeunMo", size: 24))
                }
                .padding(.horizontal)
                
                // 캐릭터 표시
                VStack {
                    if !characterViewModel.characterImages.isEmpty {
                        Image(characterViewModel.characterImages[characterViewModel.currentImageIndex])
                            .resizable()
                            .frame(width: 170, height: 170)
                            .onAppear {
                                characterViewModel.startImageAnimation()
                                checkEvolutionCondition()
                            }
                            .padding()
                            .padding(.top, 30)
                    } else {
                        Text("캐릭터 이미지 로딩 중...")
                            .font(.custom("DungGeunMo", size: 10))
                            .frame(width: 170, height: 170)
                            .padding()
                            .padding(.top, 30)
                    }
                }
                
                // 캐릭터 레벨
                Text("level.\(characterViewModel.evolutionLevel)")
                    .font(.custom("DungGeunMo", size: 20))
                    .foregroundColor(.gray)
            }
        }
        .onChange(of: characterViewModel.experience) { _, _ in
            checkEvolutionCondition()
        }
    }
    
    private func checkEvolutionCondition() {
        if characterViewModel.experience >= characterViewModel.maxExperience {
            showEvolutionModal = true
        }
    }
}

//#Preview {
//    UserCharacterInfoView()
//}
