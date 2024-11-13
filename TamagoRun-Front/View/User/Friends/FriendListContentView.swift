//
//  FriendListContentView.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/13/24.
//

import SwiftUI

struct FriendListContentView: View {
    @ObservedObject var viewModel: FriendListViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.friendList) { friend in
                NavigationLink(destination: FriendRecordView(friendId: friend.friendId)) {
                    VStack(spacing: 0) {
                        HStack {
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
                                .padding(.horizontal)
                            
                            Text(friend.friendId)
                                .font(.custom("DungGeunMo", size: 25))
                            
                            Spacer()
                        }
                        .padding(.vertical, 8)
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray.opacity(0.2))
                    }
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.white)
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
        .scrollContentBackground(.hidden)
        .background(Color.white)
    }
}
