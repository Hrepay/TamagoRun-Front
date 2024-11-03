//
//  StatisticRow.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/3/24.
//

import SwiftUI

struct StatisticRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.custom("DungGeunMo", size: 18))
                .foregroundColor(.gray)
            Text(value)
                .font(.custom("DungGeunMo", size: 40))
                .foregroundColor(.black)
                .padding(.bottom, 10)
        }
    }
}

//#Preview {
//    StatisticRow()
//}
