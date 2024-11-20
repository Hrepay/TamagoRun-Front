//
//  Manual1View.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/19/24.
//

import SwiftUI

struct Manual1View: View {
    var body: some View {
        VStack(spacing: 20) {
            Image("Manual1") // 매뉴얼 이미지
                .resizable()
                .scaledToFit()
                .frame(height: 100)
            
            Text("Character")
                .font(.custom("DungGeunMo", size: 24))
                .padding(.vertical, 40)
            
            
            Text("1. TamagoRun은 Creature, Undead, Human 세 가지의 종족으로 이루어져 있으며, 한 종족당 3가지의 직업을 가지고 있습니다!")
                .font(.custom("DungGeunMo", size: 17))
                .frame(width: .infinity)
                .padding(.horizontal)
            
            Text("2. 캐릭터들은 3개의 단계를 거쳐 진화합니다!")
                .font(.custom("DungGeunMo", size: 17))
                .frame(width: .infinity)
                .padding(.horizontal)
            
        }
        .padding()
    }
}
#Preview {
    Manual1View()
}
