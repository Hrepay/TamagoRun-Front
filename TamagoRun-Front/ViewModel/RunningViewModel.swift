//
//  RunningViewModel.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 10/5/24.
//

import Foundation
import SwiftUI
import NMapsMap
import CoreLocation

class RunningViewModel: ObservableObject {
    @Published var runningData: RunningData
    @Published var coordinates: [NMGLatLng]
    
    private let runningService = RunningService()
    
    init(runningData: RunningData, coordinates: [NMGLatLng]) {
        self.runningData = runningData
        self.coordinates = coordinates
    }
    
    func updateRunningData(_ newData: RunningData) {
        self.runningData = newData
    }
    
    func updateCoordinates(_ newCoordinates: [NMGLatLng]) {
        self.coordinates = newCoordinates
    }
    
    func uploadRunningData() {
        print("전송 전 데이터 확인 - 거리: \(runningData.distance), 페이스: \(runningData.pace), 칼로리: \(runningData.calories)")
        runningService.uploadRunningData(runningData: runningData, coordinates: coordinates) { success in
            DispatchQueue.main.async {
                if success {
                    print("러닝 데이터가 성공적으로 서버에 업로드되었습니다.")
                } else {
                    print("러닝 데이터 업로드에 실패했습니다.")
                }
            }
        }
    }
}
