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
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
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
                    .padding(.vertical,20)
                
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.friendList.isEmpty {
                    FriendEmptyView(showAddBtn: $showAddBtn)
                } else {
                    ZStack {
                        Color.white
                            .ignoresSafeArea()
                        
                        List {
                            ForEach(viewModel.friendList) { friend in
                                VStack(spacing: 0) {
                                    HStack {
                                        // 캐릭터 이미지
                                        let imageName = CharacterImages.getCharacterImages(
                                            characterCode: friend.species * 100 + friend.kindOfCharacter * 10 + friend.evolutionLevel
                                        ).first ?? ""
                                        
                                        Image(imageName)
                                            .resizable()
                                            .frame(width: 70, height: 70)
                                            .clipShape(Circle())
                                            .overlay(
                                                Circle().stroke(Color.gray, lineWidth: 1)
                                            )
                                            .padding(20)
                                        
                                        // 친구 ID
                                        Text(friend.friendId)
                                            .font(.custom("DungGeunMo", size: 25))
                                        
                                        Spacer()
                                    }
                                    .padding(.vertical, 8)
                                    
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(.gray.opacity(0.2))
                                }
                                .listRowInsets(EdgeInsets()) // 리스트 아이템의 기본 패딩 제거
                                .listRowBackground(Color.white) // 각 행의 배경색을 하얀색으로
                            }
                            .onDelete { indexSet in
                                guard let index = indexSet.first else { return }
                                let friendToDelete = viewModel.friendList[index]
                                Task {
                                    await viewModel.deleteFriend(friendId: friendToDelete.friendId)
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                        .background(Color.white)
                    }
                }

            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showAddBtn) {
            FriendAddView(viewModel: viewModel)
                .presentationDetents([.fraction(0.65)])
        }
        .task {
            await viewModel.fetchFriendList()  // 화면 로드시 친구 목록 가져오기
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
