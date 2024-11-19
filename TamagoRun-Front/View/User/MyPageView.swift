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
           .padding(.bottom,20)
           
           
           
           //MARK: - Content
           Text("My Page")
               .font(.custom("DungGeunMo", size: 30))
               .padding(.bottom, 30)
           
           ZStack {
               Image("myPage_textField")
                   .resizable()
                   .frame(width: 245, height: 50)
               
               Text("ID : \(viewModel.userId)")
                   .font(.custom("DungGeunMo", size: 18))
                   .foregroundColor(.black)
           }
           
           ZStack {
               Image("Record_box")
                   .resizable()
                   .aspectRatio(contentMode: .fit)
               
               VStack {
                   
                   // 로딩 중인 경우 ProgressView 표시
                   if viewModel.isLoading {
                       ProgressView()
                   } else {
                       // 통계 데이터 표시
                       VStack(alignment: .center, spacing: 8) {
                           MyStatisticRow(
                               title: "총 KM",
                               type: .distance,
                               value: viewModel.totalDistanceValue
                           )
                           MyStatisticRow(
                               title: "총 칼로리",
                               type: .calories,
                               value: viewModel.totalCaloriesValue
                           )
                           MyStatisticRow(
                               title: "전체 평균 페이스",
                               type: .pace,
                               value: viewModel.averagePaceValue
                           )
                           MyStatisticRow(
                               title: "총 시간",
                               type: .time,
                               value: viewModel.totalTimeValue
                           )
                       }
                   }
               }
               .frame(maxWidth: .infinity, maxHeight: .infinity)
           }
           .padding(.horizontal)

           
           if let errorMessage = viewModel.errorMessage {
               Text(errorMessage)
                   .foregroundColor(.red)
                   .font(.custom("DungGeunMo", size: 16))
                   .padding(.vertical, 10)
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
