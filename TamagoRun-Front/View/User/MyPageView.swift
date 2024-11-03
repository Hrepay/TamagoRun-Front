    //
//  MyPageView.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/3/24.
//

import SwiftUI

struct MyPageView: View {
    var body: some View {
        VStack {
            Spacer()
            // 상단 마이 페이지
            Text("My Page")
                .font(.custom("DungGeunMo", size: 30))
                .padding(.bottom, 40)
            
            // 닉네임 바
            ZStack {
                Image("myPage_textField")
                    .resizable()
                    .frame(width: 245, height: 50)
                
                Text("ID : TamagoRun")
                    .font(.custom("DungGeunMo", size: 18))
                    .foregroundColor(.black)
            }
            .padding(.bottom, 50)

            
            // 내 기록
            ZStack {
                Text("Record")
                    .font(.custom("DungGeunMo", size: 30))
                    .padding(.bottom, 35)
                
                Rectangle()
                    .frame(height: 1) // 밑줄 두께 설정
                    .foregroundColor(.black) // 밑줄 색상 설정
                    .frame(maxWidth: 90) // 밑줄 길이 설정
            }
            
            VStack (alignment: .leading) {
                Text("총 KM")
                    .font(.custom("DungGeunMo", size: 18))
                    .foregroundColor(.gray)
                Text("00.0")
                    .font(.custom("DungGeunMo", size: 40))
                    .foregroundColor(.black)
                    .padding(.bottom,10)
                
                Text("총 칼로리")
                    .font(.custom("DungGeunMo", size: 18))
                    .foregroundColor(.gray)
                Text("0")
                    .font(.custom("DungGeunMo", size: 40))
                    .foregroundColor(.black)
                    .padding(.bottom,10)
                
                Text("전체 평균 페이스")
                    .font(.custom("DungGeunMo", size: 18))
                    .foregroundColor(.gray)
                Text("0'00''")
                    .font(.custom("DungGeunMo", size: 40))
                    .foregroundColor(.black)
                    .padding(.bottom,10)
                
                Text("총 시간")
                    .font(.custom("DungGeunMo", size: 18))
                    .foregroundColor(.gray)
                Text("0:00:00")
                    .font(.custom("DungGeunMo", size: 40))
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 50)
            
            Spacer()
        }
    }
}

#Preview {
    MyPageView()
}
