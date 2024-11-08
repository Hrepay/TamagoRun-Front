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
                
                VStack {
                    Text("종족")
                        .font(.custom("DungGeunMo", size: 20))
                        .padding(.vertical, 20)
                    
                    Text("한번 선택하면 바꿀 수 없습니다.")
                        .font(.custom("DungGeunMo", size: 12))
                        .foregroundColor(.red)
                        .padding(.bottom)
                    // Creature 버튼
                    Button(action: {
                        viewModel.selectedRace = "Creature"
                    }) {
                        HStack {
                            Text("Creature")
                                .font(.custom("DungGeunMo", size: 33))
                                .foregroundStyle(viewModel.selectedRace == "Creature" ? Color.black : Color.gray)
                            
                            Spacer()
                            
                            Text("심볼")
                                .font(.custom("DungGeunMo", size: 20))
                                .foregroundColor(.gray)
                                .padding(8)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(5)
                        }
                        .frame(height: 80)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(viewModel.selectedRace == "Creature" ? Color.black : Color.gray, lineWidth: 2)
                        )
                    }
                    .padding(.horizontal, 15)
                    
                    // Undead 버튼
                    Button(action: {
                        viewModel.selectedRace = "Undead"
                    }) {
                        HStack {
                            Text("Undead")
                                .font(.custom("DungGeunMo", size: 33))
                                .foregroundStyle(viewModel.selectedRace == "Undead" ? Color.black : Color.gray)
                            
                            Spacer()
                            
                            Text("심볼")
                                .font(.custom("DungGeunMo", size: 20))
                                .foregroundColor(.gray)
                                .padding(8)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(5)
                        }
                        .frame(height: 80)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(viewModel.selectedRace == "Undead" ? Color.black : Color.gray, lineWidth: 2)
                        )
                    }
                    .padding(.horizontal, 15)
                    
                    // Animal 버튼
                    Button(action: {
                        viewModel.selectedRace = "Animal"
                    }) {
                        HStack {
                            Text("Animal")
                                .font(.custom("DungGeunMo", size: 33))
                                .foregroundStyle(viewModel.selectedRace == "Animal" ? Color.black : Color.gray)
                            
                            Spacer()
                            
                            Text("심볼")
                                .font(.custom("DungGeunMo", size: 20))
                                .foregroundColor(.gray)
                                .padding(8)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(5)
                        }
                        .frame(height: 80)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(viewModel.selectedRace == "Animal" ? Color.black : Color.gray, lineWidth: 2)
                        )
                    }
                    .padding(.horizontal, 15)
                    
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
