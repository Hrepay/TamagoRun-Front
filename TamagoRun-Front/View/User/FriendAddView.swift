//
//  FriendAddView.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/5/24.
//

import SwiftUI

struct FriendAddView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: FriendListViewModel
    @State private var isPressed: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("친구 추가하기")
                .font(.custom("DungGeunMo", size: 20))
                .padding(.top, 35)
                .padding(.bottom, 20)
            
            TextField("닉네임", text: $viewModel.nickname)
                .font(.custom("DungGeunMo", size: 20))
                .padding(20)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .frame(height: 65)
                .padding(.horizontal, 40)
                .disabled(viewModel.isLoading)
            
            Button(action: {
                Task {
                    await viewModel.addFriend()
                }
            }) {
                Text(viewModel.isLoading ? "처리중..." : "확인")
                    .font(.custom("DungGeunMo", size: 18))
                    .frame(maxWidth: .infinity)
                    .frame(height: 65)
                    .background(isPressed ? Color.black : Color(.systemGray6))
                    .foregroundColor(isPressed ? Color.white : Color.black)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
            .buttonStyle(PlainButtonStyle())
            .disabled(viewModel.isLoading)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ _ in isPressed = true })
                    .onEnded({ _ in isPressed = false })
            )
            
            Spacer()
        }
        .alert("알림", isPresented: $viewModel.showAlert) {
            Button("확인") {
                if viewModel.alertMessage.contains("추가했습니다") {
                    dismiss()
                }
            }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}

//#Preview {
//    FriendAddView()
//}
