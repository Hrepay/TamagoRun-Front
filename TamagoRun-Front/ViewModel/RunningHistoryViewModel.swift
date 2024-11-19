//
//  RunningHistoryViewModel.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/19/24.
//

import Foundation
import SwiftUI
import NMapsMap
import CoreLocation

class RunningHistoryViewModel: ObservableObject {
    @Published var coordinates: [NMGLatLng] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let userService = UserService.shared
    
    func fetchRunningPath(for date: Date) {
        isLoading = true
        
        Task {
            do {
                let record = try await userService.fetchRunningHistory(for: date)
                DispatchQueue.main.async {
                    self.coordinates = record.coordinates.map { NMGLatLng(lat: $0.x, lng: $0.y) }
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}
