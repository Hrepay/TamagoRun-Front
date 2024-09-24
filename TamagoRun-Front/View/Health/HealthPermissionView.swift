//
//  HealthPermissionView.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 9/24/24.
//

import SwiftUI

struct HealthPermissionView: View {
    var body: some View {
        VStack {
            Text("권한을 허용해주세요!")
                .font(.custom("DungGeunMo", size: 20))
                .padding()
            
            Image("health_icon")
                .resizable()
                .frame(width: 75, height: 75)
            
            Text("TamagoRun은 러닝 데이터를 위해 \n건강 앱에 데이터를 저장하고 있습니다!\n\n러닝의 데이터 정보를 위해 설정에서\n건강앱의 권한을 허용해주세요!")
                .font(.custom("DungGeunMo", size: 15))
                .multilineTextAlignment(.center)
                .padding()
                .padding(.horizontal)
            
            Text("설정에서 TamagoRun의 건강 데이터 권한을 허용해주세요.")
                .font(.custom("DungGeunMo", size: 15))
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}

#Preview {
    HealthPermissionView()
}
