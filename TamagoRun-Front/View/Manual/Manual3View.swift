//
//  Manual1View.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/19/24.
//

import SwiftUI

struct Manual3View: View {
    var body: some View {
        VStack(spacing: 20) {
            Image("manual_image_1") // 매뉴얼 이미지
                .resizable()
                .scaledToFit()
                .frame(height: 300)
            
            Text("게임 시작하기")
                .font(.custom("DungGeunMo", size: 24))
                .padding(.top)
            
            Text("캐릭터를 선택하고\n게임을 시작해보세요!")
                .font(.custom("DungGeunMo", size: 16))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    Manual3View()
}
