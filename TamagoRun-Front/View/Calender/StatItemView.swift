//
//  StatItemView.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/10/24.
//

import SwiftUI

struct StatItemView: View {
    let title: String
    let value: String
    let iconName: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: iconName)
                .font(.system(size: 24))
            Text(title)
                .font(.custom("DungGeunMo", size: 14))
                .foregroundColor(.gray)
            Text(value)
                .font(.custom("DungGeunMo", size: 16))
        }
        .frame(width: 100)
    }
}

//#Preview {
//    StatItemView()
//}
