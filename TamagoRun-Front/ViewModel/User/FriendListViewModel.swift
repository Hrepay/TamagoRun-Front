//
//  FriendListViewModel.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/11/24.
//

import Foundation

class FriendListViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var nickname = ""
    @Published var friendList: [Friend] = []  // 임시로 String 배열로 구현
    
    private let friendService = FriendService.shared
    static let shared = FriendListViewModel()

    
    func fetchFriendList() async {
        await MainActor.run { isLoading = true }
        
        do {
            let friends = try await friendService.getFriendList()
            await MainActor.run {
                self.friendList = friends
            }
        } catch {
            await MainActor.run {
                if let networkError = error as? NetworkError {
                    alertMessage = networkError.message
                } else {
                    alertMessage = "친구 목록을 불러오는데 실패했습니다."
                }
                showAlert = true
            }
        }
        
        await MainActor.run { isLoading = false }
    }
    
    func addFriend() async {
        guard !nickname.isEmpty else {
            await MainActor.run {
                alertMessage = "닉네임을 입력해주세요"
                showAlert = true
            }
            return
        }
        
        await MainActor.run { isLoading = true }
        
        do {
            let success = try await friendService.addFriend(friendId: nickname)
            
            await MainActor.run {
                alertMessage = success ? "\(nickname)님을 친구로 추가했습니다" : "친구 추가에 실패했습니다"
                showAlert = true
                
                if success {
                    Task {
                        await fetchFriendList()  // 친구 추가 성공시 목록 갱신
                    }
                }
            }
        } catch {
            await MainActor.run {
                if let networkError = error as? NetworkError {
                    alertMessage = networkError.message
                } else {
                    alertMessage = "오류가 발생했습니다: \(error.localizedDescription)"
                }
                showAlert = true
            }
        }
        
        await MainActor.run {
            isLoading = false
            nickname = ""
        }
    }

    // 친구 삭제
    func deleteFriend(friendId: String) async {
        await MainActor.run { isLoading = true }
        
        do {
            // UserDefaults에서 sessionId 가져오기
            let sessionId = UserDefaults.standard.string(forKey: "sessionID") ?? ""
            let success = try await friendService.deleteFriend(friendId: friendId, sessionId: sessionId)
            
            await MainActor.run {
                if success {
                    // 성공 시 목록 갱신
                    alertMessage = "친구가 삭제되었습니다"
                    showAlert = true
                    Task {
                        await fetchFriendList()
                    }
                } else {
                    alertMessage = "친구 삭제에 실패했습니다"
                    showAlert = true
                }
            }
        } catch {
            await MainActor.run {
                if let networkError = error as? NetworkError {
                    alertMessage = networkError.message
                } else {
                    alertMessage = "오류가 발생했습니다: \(error.localizedDescription)"
                }
                showAlert = true
            }
        }
        
        await MainActor.run { isLoading = false }
    }
}
