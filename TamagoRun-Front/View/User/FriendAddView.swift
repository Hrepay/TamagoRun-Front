//
//  FriendAddView.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/5/24.
//

import SwiftUI

struct FriendAddView: View {
    @State private var nickname: String = ""
    @State private var isPressed: Bool = false // 버튼 상태를 관리할 변수 추가
    
    var body: some View {
        VStack(spacing: 20) {
            Text("친구 추가하기")
                .font(.custom("DungGeunMo", size: 20))
                .padding(.top, 35)
                .padding(.bottom, 20)
                
            
            TextField("닉네임", text: $nickname)
                .font(.custom("DungGeunMo", size: 20))
                .padding(20)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .frame(height: 65)
                .padding(.horizontal, 40)
                


            Button(action: {
                // 확인 버튼 액션
            }) {
                Text("확인")
                    .font(.custom("DungGeunMo", size: 18))
                    .frame(maxWidth: .infinity)
                    .frame(height: 65)
                    .background(isPressed ? Color.black : Color(.systemGray6)) // 상태에 따라 배경색 변경
                    .foregroundColor(isPressed ? Color.white : Color.black)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
            .buttonStyle(PlainButtonStyle()) // 기본 버튼 스타일 제거
            .simultaneousGesture( // 터치 제스처 추가
                DragGesture(minimumDistance: 0)
                    .onChanged({ _ in
                        isPressed = true
                    })
                    .onEnded({ _ in
                        isPressed = false
                    })
            )
            Spacer()
        }
    }
}

#Preview {
    FriendAddView()
}
