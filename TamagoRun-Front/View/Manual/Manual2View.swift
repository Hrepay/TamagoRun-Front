//
//  Manual1View.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/19/24.
//

import SwiftUI

struct Manual2View: View {
    var body: some View {
        VStack(spacing: 25) {
            
            Text("Running")
                .font(.custom("DungGeunMo", size: 25))
                .padding(.bottom, 20)
            
            Image("manual_running") // 매뉴얼 이미지
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .padding(.vertical, 30)
            
            VStack {
                Text("1. 마이페이지 및 달력의 러닝 경로에는 해당 앱을 통해 기록한 데이터가 사용됩니다.")
                    .font(.custom("DungGeunMo", size: 17))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)

                Text("2. 러닝 통계와 달력에서는 기존의 러닝 데이터도 확인 가능합니다.")
                    .font(.custom("DungGeunMo", size: 17))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            
        }
        .padding()
    }
}

#Preview {
    Manual2View()
}
