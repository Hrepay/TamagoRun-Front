//
//  EvolutionModalView.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/14/24.
//

import Foundation
import SwiftUI

struct EvolutionModalView: View {
    @ObservedObject var characterViewModel: CharacterViewModel
    @Binding var isPresented: Bool
    @State private var startEvolution = false
    @State private var evolutionText = "알이 부화하려고 합니다!"
    
    var body: some View {
        VStack(spacing: 20) {
            // 텍스트 표시 부분은 한 번만
            if characterViewModel.evolutionCompleted {
                Text("축하합니다! 캐릭터가 진화했습니다!")
                    .font(.custom("DungGeunMo", size: 20))
                    .multilineTextAlignment(.center)  // 중앙 정렬 추가
                    .padding()
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                Text(characterViewModel.isEggState ? "알이 부화하려고 합니다!" : "캐릭터가 진화하려고 합니다!")
                    .font(.custom("DungGeunMo", size: 20))
                    .multilineTextAlignment(.center)  // 중앙 정렬 추가
                    .padding()
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            if characterViewModel.isEggState {
                if !startEvolution {
                    // 부화 전 알 상태 (gif 효과 적용)
                    Image(characterViewModel.characterImages[characterViewModel.currentImageIndex])
                        .resizable()
                        .frame(width: 200, height: 200)
                        .onAppear {
                            characterViewModel.startImageAnimation()
                        }
                        .onTapGesture {
                            startEvolution = true
                            characterViewModel.startHatchingAnimation {
                            }
                        }
                } else if !characterViewModel.evolutionCompleted {
                    // 부화 중
                    Image("hatchEgg_\(characterViewModel.currentEggIndex)")
                        .resizable()
                        .frame(width: 200, height: 200)
                } else {
                    // 부화 후 새 캐릭터
                    Image(characterViewModel.characterImages[characterViewModel.currentImageIndex])
                        .resizable()
                        .frame(width: 200, height: 200)
                }
            } else {
                // Text 부분 제거하고 이미지만 표시
                if !startEvolution {
                    // 진화 전 캐릭터
                    Image(characterViewModel.characterImages[characterViewModel.currentImageIndex])
                        .resizable()
                        .frame(width: 200, height: 200)
                        .onTapGesture {
                            startEvolution = true
                            characterViewModel.startEvolutionAnimation {
                            }
                        }
                } else {
                    // 진화 중이거나 완료된 캐릭터
                    Image(characterViewModel.characterImages[characterViewModel.currentImageIndex])
                        .resizable()
                        .frame(width: 200, height: 200)
                        .opacity(characterViewModel.isEvolutionAnimating ? 0.5 : 1.0)
                }
            }
            
            if characterViewModel.evolutionCompleted {
                Button(action: {
                    isPresented = false
                }) {
                    Text("닫기")
                        .font(.custom("DungGeunMo", size: 20))
                        .padding()
                        .frame(width: 160, height: 40)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.black, lineWidth: 2)
                        )
                }
            }
        }
        .padding()
    }
}
