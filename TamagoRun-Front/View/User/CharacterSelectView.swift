//
//  CharacterSelectView.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/7/24.
//

import SwiftUI

struct CharacterSelectView: View {
    @Binding var isPresented: Bool
    let onCharacterSelected: (Bool) -> Void
    @StateObject private var viewModel = CharacterSelectionViewModel()
    
    var body: some View {
        ZStack {
            // 반투명 회색 배경
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
        //MARK: - header
                VStack {
                    Text("종족")
                        .font(.custom("DungGeunMo", size: 20))
                        .padding(.vertical, 20)
                    
                    Text("한번 선택하면 바꿀 수 없습니다.")
                        .font(.custom("DungGeunMo", size: 12))
                        .foregroundColor(.red)
                        .padding(.bottom)
                    
        //MARK: - content
                    // Creature 버튼
                    Button(action: {
                        viewModel.selectedRace = "Creature"
                    }) {
                        VStack {
                            VStack {
                                Image("creature_simbol")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .opacity(viewModel.selectedRace == "Creature" ? 1.0 : 0.4)
                            }
                            .frame(width: 120, height: 120)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(viewModel.selectedRace == "Creature" ? Color.black : Color.gray, lineWidth: 2)
                            )
                            Text("Creature")
                                .font(.custom("DungGeunMo", size: 20))
                                .foregroundColor(viewModel.selectedRace == "Creature" ? .black : .gray)
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.bottom, 10)
                    
                    HStack {
                        // Undead 버튼
                        Button(action: {
                            viewModel.selectedRace = "Undead"
                        }) {
                            VStack {
                                VStack {
                                    Image("undead_simbol")
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .opacity(viewModel.selectedRace == "Creature" ? 1.0 : 0.4)
                                }
                                .frame(width: 120, height: 120)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(viewModel.selectedRace == "Undead" ? Color.black : Color.gray, lineWidth: 2)
                                )
                                Text("Undead")
                                    .font(.custom("DungGeunMo", size: 20))
                                    .foregroundColor(viewModel.selectedRace == "Undead" ? .black : .gray)
                            }
                        }
                        .padding(.horizontal, 15)
                        
                        // Human 버튼
                        Button(action: {
                            viewModel.selectedRace = "Human"  // 이전에 "Undead"로 되어있던 버그 수정
                        }) {
                            VStack {
                                VStack {
                                    Image("human_simbol")
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .opacity(viewModel.selectedRace == "Creature" ? 1.0 : 0.4)
                                }
                                .frame(width: 120, height: 120)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(viewModel.selectedRace == "Human" ? Color.black : Color.gray, lineWidth: 2)
                                )
                                Text("Human")
                                    .font(.custom("DungGeunMo", size: 20))
                                    .foregroundColor(viewModel.selectedRace == "Human" ? .black : .gray)
                            }
                        }
                        .padding(.horizontal, 15)
                    }
                    
                    // 확인 버튼
                    Button(action: {
                        viewModel.selectSpecies { success in
                            if success {
                                onCharacterSelected(true)
                                isPresented = false
                            }
                        }
                    }) {
                        Image("ok_bt2")
                            .resizable()
                            .frame(width: 100, height: 60)
                    }
                    .disabled(viewModel.selectedRace == nil || viewModel.isLoading)
                    .padding()
                    
                    if viewModel.isLoading {
                        ProgressView()
                    }
                }
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(20)
                .padding()
                
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

// Preview 수정
#Preview {
    CharacterSelectView(
        isPresented: .constant(true),
        onCharacterSelected: { _ in }
    )
}
