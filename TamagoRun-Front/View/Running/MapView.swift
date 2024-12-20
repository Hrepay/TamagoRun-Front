//
//  MapViewController.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 9/26/24.
//

import SwiftUI
import NMapsMap
import CoreLocation

// 사실은 컨트롤러..
struct MapView: UIViewControllerRepresentable {
    
    @Binding var coordinates: [NMGLatLng]
    @Binding var mapView: NMFMapView?
    @ObservedObject var runningData: RunningData // RunningData를 전달받음
    var isRunning: Bool = true  // 추가: 러닝 상태를 나타내는 프로퍼티
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let naverMapView = NMFNaverMapView(frame: UIScreen.main.bounds)
        naverMapView.showLocationButton = true
        naverMapView.showScaleBar = true
        naverMapView.mapView.positionMode = .direction
        viewController.view.addSubview(naverMapView)
        
        let initialCameraUpdate = NMFCameraUpdate(zoomTo: 15.0)
        naverMapView.mapView.moveCamera(initialCameraUpdate)
        
        DispatchQueue.main.async {
            self.mapView = naverMapView.mapView
        }
        
        context.coordinator.mapView = naverMapView.mapView
        context.coordinator.locationManager.delegate = context.coordinator
        context.coordinator.locationManager.startUpdatingLocation()
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if !isRunning {
            context.coordinator.stopUpdates()  // 러닝이 중지되면 위치 업데이트도 중지
        }
        context.coordinator.updatePathOverlay(coordinates: coordinates)
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func stopLocationUpdates() {
        // 기존의 복잡한 처리 대신 단순히 위치 업데이트만 중지
        self.mapView?.positionMode = .disabled
    }
    
    class Coordinator: NSObject, CLLocationManagerDelegate {
        var parent: MapView
        var mapView: NMFMapView?
        var pathOverlay: NMFPath?
        var locationManager = CLLocationManager()
        var lastLocation: CLLocation? // 이전 위치 저장
        var lastUpdateTime: Date? // 마지막으로 위치를 업데이트한 시간
        
        init(_ parent: MapView) {
            self.parent = parent
            super.init()
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            // 백그라운드 위치 업데이트 설정
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.pausesLocationUpdatesAutomatically = false
        }
        
        func updatePathOverlay(coordinates: [NMGLatLng]) {
            guard coordinates.count >= 2 else { return }
            
            if pathOverlay == nil {
                pathOverlay = NMFPath()
                pathOverlay?.color = .green
                pathOverlay?.outlineColor = .white
                pathOverlay?.width = 5
                pathOverlay?.mapView = mapView
            }
            
            pathOverlay?.path = NMGLineString(points: coordinates)
            pathOverlay?.mapView = mapView
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }

            // 3초마다 위치를 업데이트
            let now = Date()
            if let lastTime = lastUpdateTime, now.timeIntervalSince(lastTime) < 3 {
                return
            }
            lastUpdateTime = now

            let currentLatLng = NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude)

            let cameraUpdate = NMFCameraUpdate(position: NMFCameraPosition(currentLatLng, zoom: 17.0))
            cameraUpdate.animation = .easeIn
            mapView?.moveCamera(cameraUpdate)

            parent.coordinates.append(currentLatLng)
            updatePathOverlay(coordinates: parent.coordinates)

            if let lastLocation = lastLocation {
                let distanceDelta = location.distance(from: lastLocation) / 1000.0 // m -> km
                let elapsedTime = now.timeIntervalSince(lastLocation.timestamp)
                
                DispatchQueue.main.async {
                    self.parent.runningData.objectWillChange.send()
                    self.parent.runningData.distance += distanceDelta
                    self.parent.runningData.elapsedTime += elapsedTime
                    
                    // Update pace
                    if self.parent.runningData.distance > 0 {
                        self.parent.runningData.pace = Int(self.parent.runningData.elapsedTime / self.parent.runningData.distance)
                    }

                    // Update calories
                    let standardWeight = 70.0  // 한국 성인 평균 체중 (kg)
                    let totalTimeInHours = self.parent.runningData.elapsedTime / 3600.0
                    let met = 5.0 // 일반적인 조깅/달리기의 MET 값
                                        
                    // 칼로리 계산: MET * 체중(kg) * 시간(hour)
                    let totalCalories = met * standardWeight * totalTimeInHours
                                        
                    // 소수점 이하를 버리지 않고 반올림
                    self.parent.runningData.calories = Int(round(totalCalories))

                    
                    print("Updated - Distance: \(self.parent.runningData.distance), Pace: \(self.parent.runningData.pace), Calories: \(self.parent.runningData.calories), Time: \(self.parent.runningData.elapsedTime)")
                }
            }

            self.lastLocation = location
        }
    }
}

extension MapView.Coordinator {
    func stopUpdates() {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil  // 델리게이트도 해제
    }
}
