//
//  SwiftUIView.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/12/24.
//

import SwiftUI

struct FriendRecordView: View {
    let friendId: String
    @StateObject private var viewModel = FriendListViewModel.shared
    @Environment(\.presentationMode) var presentationMode
    @State private var userRecord: UserRecord?
    @State private var isLoading = false
    @State private var errorMessage: String?
    
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
            .padding(.bottom, 20)
            
            //MARK: - Content
            Text("\(friendId)'s Record")
                .font(.custom("DungGeunMo", size: 30))
                .padding(.bottom, 30)
            
            ZStack {
                Image("myPage_textField")
                    .resizable()
                    .frame(width: 245, height: 50)
                
                Text("ID : \(friendId)")
                    .font(.custom("DungGeunMo", size: 18))
                    .foregroundColor(.black)
            }
            
            ZStack {
                Image("Record_box")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                VStack {
                    if isLoading {
                        ProgressView()
                    } else if let record = userRecord {
                        VStack(alignment: .center, spacing: 8) {
                            MyStatisticRow(title: "총 KM", type: .distance, value: Double(record.totalRunningDistance))
                            MyStatisticRow(title: "총 칼로리", type: .calories, value: Double(record.totalCalorie))
                            MyStatisticRow(title: "전체 평균 페이스", type: .pace, value: Double(record.overallAveragePace))
                            MyStatisticRow(title: "총 시간", type: .time, value: Double(record.totalRunningTime))
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(.horizontal)
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.custom("DungGeunMo", size: 16))
                    .padding(.vertical, 10)
            }
            
            Spacer()
        }
        .task {
            await loadFriendRecord()
        }
        .navigationBarHidden(true)
    }
    
    private func loadFriendRecord() async {
        isLoading = true
        do {
            userRecord = try await viewModel.getFriendRunningData(friendId: friendId)
        } catch {
            if let networkError = error as? NetworkError {
                errorMessage = networkError.message
            } else {
                errorMessage = "데이터를 불러오는데 실패했습니다."
            }
        }
        isLoading = false
    }
}

//#Preview {
//    FriendRecordView()
//}
