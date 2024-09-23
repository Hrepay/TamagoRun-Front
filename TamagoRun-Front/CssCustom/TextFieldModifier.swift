//
//  SwiftUIView.swift
//  TestProject
//
//  Created by 황상환 on 9/12/24.
//

import SwiftUI

// 첫 번째 커스텀 텍스트 필드 스타일
struct CustomTextField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .font(.custom("DungGeunMo", size: 15))
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 2)
            )
            .padding(.leading, 40)
            .padding(.trailing, 40)
            .padding(.bottom, 5)
    }
}

// 두 번째 버튼 스타일
struct CustomButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .font(.custom("DungGeunMo", size: 20))
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding(.horizontal, 20)
    }
}

// 세 번째 커스텀 라벨 스타일
struct CustomLabelModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("DungGeunMo", size: 20))
            .foregroundColor(.gray)
            .padding(.bottom, 10)
    }
}

// View extension을 통해 재사용 가능한 메서드로 확장
extension View {
    func customTextFieldStyle() -> some View {
        self.modifier(CustomTextField())
    }
    
    func customButtonStyle() -> some View {
        self.modifier(CustomButtonModifier())
    }
    
    func customLabelStyle() -> some View {
        self.modifier(CustomLabelModifier())
    }
}
