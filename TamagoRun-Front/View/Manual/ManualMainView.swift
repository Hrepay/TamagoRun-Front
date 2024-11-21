//
//  ManualMainView.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/19/24.
//

import SwiftUI

struct ManualMainView: View {
    @State private var currentPage = 0
    @Binding var isPresented: Bool
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // 배경 오버레이
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // 메뉴얼 컨텐츠
                TabView(selection: $currentPage) {
                    Manual1View()
                        .tag(0)
                    
                    Manual2View()
                        .tag(1)
                    
                    Manual3View()
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .frame(height: 530)  // 높이 조절 가능
                
                // 페이지 인디케이터와 버튼
                HStack {
                    // 페이지 표시
                    HStack(spacing: 8) {
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(currentPage == index ? Color.black : Color.gray)
                                .frame(width: 8, height: 8)
                        }
                    }
                    
                    Spacer()
                    
                    // 건너뛰기/시작하기 버튼
                    Button(action: {
                        isPresented = false
                        dismiss()
                    }) {
                        Text(currentPage == 2 ? "시작하기" : "건너뛰기")
                            .font(.custom("DungGeunMo", size: 16))
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
            }
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(20)
            .padding()
        }
    }
}

// Preview 수정
#Preview {
    ManualMainView(isPresented: .constant(true))
}
