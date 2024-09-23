//
//  SwiftUIView.swift
//  TestProject
//
//  Created by 황상환 on 9/9/24.
//

import SwiftUI

struct StartView: View {
    
    let buttonImage = ["start_1", "start_2"]
    let logo_Image = ["logo"]
    
    var body: some View {
        
        NavigationView {
            VStack {
                Spacer()
                
//                Text("TamagoRun")
//                    .font(.custom("DungGeunMo", size: 50))
//                    .padding(.bottom, 40)
                Image(logo_Image[0])
                    .resizable()
                    .frame(width: 280, height: 170)
                    .padding(.bottom, 40)
                
                NavigationLink(destination: SignUpView()) {
                    Image(buttonImage[0]) // 여기에 원하는 이미지 이름을 넣으세요
                       .resizable()
                       .frame(width: 240, height: 50) // 이미지 크기 조정
                       .cornerRadius(15)
                }
                .foregroundColor(.black)
                .padding(.bottom, 5)
                                
                NavigationLink(destination: LoginView()) {
                    Image(buttonImage[1])
                        .resizable()
                        .frame(width: 240, height: 50) // 이미지 크기 조정
                        .cornerRadius(15)
                }
                .foregroundColor(.black)
                Spacer()
            }
        }
    }
}

extension Color {
    static let lightgray = Color("lightGray")
    static let darkdarkgray = Color("darkGray")
}

#Preview {
    StartView()
}
