//
//  FriendsListView.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/4/24.
//

import SwiftUI

struct FriendsListView: View {
    
    // 뒤로가기
    @Environment(\.presentationMode) var presentationMode
    @State private var showAddBtn = false

    var body: some View {
        
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
            
            Button(action: {
                showAddBtn = true
            }) {
                HStack {
                    Image(systemName: "plus")
                        .foregroundColor(.black)
                        .font(.system(size: 20))
                }
            }
            .padding(.trailing)
            
        }
        .padding(.top)
        
        VStack {
            Text("Friends")
                .font(.custom("DungGeunMo", size: 20))
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showAddBtn) {
            FriendAddView()
                .presentationDetents([.fraction(0.65)])        }
    }
}

#Preview {
    FriendsListView()
}
