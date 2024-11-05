//
//  FriendEmptyView.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/4/24.
//

import SwiftUI

struct FriendEmptyView: View {
    
    // 친추 추가 sheet
    @State private var showAddBtn = false
    
    var body: some View {
        VStack{
            
            Text("Friends")
                .font(.custom("DungGeunMo", size: 20))
            
            Spacer()
        
            
            Image("addFriend")
                .resizable()
                .frame(width: 50, height: 50)
                .padding(.bottom, 30)
            
            Text("친구를 추가해보세요!")
                .foregroundColor(.gray)
                .font(.custom("DungGeunMo", size: 20))

            Spacer()
            
            Button(action: {
                showAddBtn = true
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("친구 추가하기")
                        .font(.custom("DungGeunMo", size: 18))
                }
                .frame(maxWidth: 240, maxHeight: 30)
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(10)
                .overlay( // 테두리 추가
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 1)
                )
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
        .sheet(isPresented: $showAddBtn) {
            FriendAddView()
                .presentationDetents([.fraction(0.65)])
        }
    }
}

#Preview {
    FriendEmptyView()
}
