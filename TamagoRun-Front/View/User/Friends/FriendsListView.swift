//
//  FriendsListView.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/4/24.
//


import SwiftUI

struct FriendsListView: View {
    @Binding var isPresented: Bool
    @State private var showAddBtn = false
    @StateObject private var viewModel = FriendListViewModel()
    
    var body: some View {
        NavigationStack { // NavigationView 대신 NavigationStack 사용
            VStack(spacing: 0) {
                // MARK: - Header
                HStack {
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .font(.system(size: 20))
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    Button(action: {
                        showAddBtn = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.black)
                            .font(.system(size: 20))
                    }
                    .padding(.trailing)
                }
                .padding(.top)
                
                // MARK: - Content
                Text("Friend")
                    .font(.custom("DungGeunMo", size: 20))
                    .padding(.vertical, 20)
                
                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else if viewModel.friendList.isEmpty {
                    Spacer()
                    FriendEmptyView(showAddBtn: $showAddBtn)
                } else {
                    FriendListContentView(viewModel: viewModel)
                }
            }
            .background(Color.white)
            .navigationBarHidden(true) // 추가
        }
        .sheet(isPresented: $showAddBtn) {
            FriendAddView(viewModel: viewModel)
                .presentationDetents([.fraction(0.65)])
        }
        .task {
            await viewModel.fetchFriendList()
        }
        .alert("알림", isPresented: $viewModel.showAlert) {
            Button("확인", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}

//#Preview {
//    FriendsListView()
//}
