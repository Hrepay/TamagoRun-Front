//
//  ContactDeveloper.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/21/24.
//

import SwiftUI

struct ContactDeveloper: View {
    
    // 뒤로가기
    @Environment(\.presentationMode) var presentationMode

    
    var body: some View {
        VStack {
            // 뒤로가기 버튼을 포함한 상단 바
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .font(.system(size: 20))
                    }
                }
                .padding(.leading)
                
                Spacer()
            }
            .padding(.top)
            .padding(.bottom,20)
            
            Spacer()
            
            Text("Q&A")
                .font(.custom("DungGeunMo", size: 25))
            
            Spacer()
            
            ZStack{
                Image("QnA_box")
                    .resizable()
                    .frame(width: 220, height: 150)
                
                Text("하이 암 선덕\n오류 발생시 아래\n메일로 문의해주세용\n\nsunduck@sunduck.com")
                    .font(.custom("DungGeunMo", size: 15))
                    .multilineTextAlignment(.center)
            }
            .padding(.bottom, 30)
            
            Image("Sun_duck")
                .resizable()
                .frame(width: 70, height: 80)
                .padding(.bottom, 50)
            
            Spacer()
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    ContactDeveloper()
}
