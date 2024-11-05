    //
//  MyPageView.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/3/24.
//

import SwiftUI

struct MyPageView: View {
   @StateObject private var viewModel = MyPageViewModel()
   @Environment(\.presentationMode) var presentationMode // 추가
   
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
           
           // 기존 코드
           Spacer()
           
           Text("My Page")
               .font(.custom("DungGeunMo", size: 30))
               .padding(.bottom, 40)
           
           ZStack {
               Image("myPage_textField")
                   .resizable()
                   .frame(width: 245, height: 50)
               
               Text("ID : \(viewModel.userId)")
                   .font(.custom("DungGeunMo", size: 18))
                   .foregroundColor(.black)
           }
           .padding(.bottom, 50)
           
           ZStack {
               Text("Record")
                   .font(.custom("DungGeunMo", size: 30))
                   .padding(.bottom, 35)
               
               Rectangle()
                   .frame(height: 1)
                   .foregroundColor(.black)
                   .frame(maxWidth: 90)
           }
           
           if viewModel.isLoading {
               ProgressView()
           } else {
               VStack(alignment: .leading) {
                   StatisticRow(title: "총 KM", value: viewModel.totalDistance)
                   StatisticRow(title: "총 칼로리", value: viewModel.totalCalories)
                   StatisticRow(title: "전체 평균 페이스", value: viewModel.averagePace)
                   StatisticRow(title: "총 시간", value: viewModel.totalTime)
               }
               .frame(maxWidth: .infinity, alignment: .leading)
               .padding(.leading, 50)
           }
           
           if let errorMessage = viewModel.errorMessage {
               Text(errorMessage)
                   .foregroundColor(.red)
                   .font(.custom("DungGeunMo", size: 16))
                   .padding(.top, 40)
           }
           
           Spacer()
       }
       .onAppear {
           viewModel.fetchUserRecord()
       }
       .navigationBarHidden(true)
   }
}


#Preview {
    MyPageView()
}
