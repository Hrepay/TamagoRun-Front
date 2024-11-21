//
//  Manual1View.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/19/24.
//

import SwiftUI

struct Manual3View: View {
    var body: some View {
        VStack(spacing: 25) {
            
            Text("Mission")
                .font(.custom("DungGeunMo", size: 25))
                .padding(.bottom, 20)
            
            Text("Mission\nComplete!")
                .font(.custom("DungGeunMo", size: 40))
                .frame(height: 100)
                .padding(.vertical, 50)
            
            VStack {
                Text("러닝을 통해 미션/업적을 클리어하고 경험치를 획득하여 캐릭터를 진화시켜보세요!")
                    .font(.custom("DungGeunMo", size: 17))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)
            }
            .padding()
            
        }
        .padding()
    }
}

#Preview {
    Manual3View()
}
