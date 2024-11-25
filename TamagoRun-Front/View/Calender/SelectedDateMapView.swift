//
//  SelectedDateMapView.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/19/24.
//

import SwiftUI
import NMapsMap

struct SelectedDateMapView: UIViewRepresentable {
    var coordinates: [NMGLatLng]

    func makeUIView(context: Context) -> NMFMapView {
        let mapView = NMFMapView()

        // 첫 번째 좌표를 기준으로 카메라 이동 및 줌 레벨 설정
        if let firstCoordinate = coordinates.first {
            let cameraPosition = NMFCameraPosition(firstCoordinate, zoom: 15.0) // 클수록 확대
            let cameraUpdate = NMFCameraUpdate(position: cameraPosition)
            cameraUpdate.animation = .easeIn
            mapView.moveCamera(cameraUpdate)
        }

        // 좌표를 이용하여 경로 그리기
        let path = NMGLineString(points: coordinates.map { $0 as AnyObject })
        if let polylineOverlay = NMFPolylineOverlay(path) {
            polylineOverlay.mapView = mapView
        }

        return mapView
    }

    func updateUIView(_ uiView: NMFMapView, context: Context) {
        // 새로운 경로 그리기
        let path = NMGLineString(points: coordinates.map { $0 as AnyObject })
        if let polylineOverlay = NMFPolylineOverlay(path) {
            polylineOverlay.mapView = uiView
        }
        
        // 카메라 업데이트
        if let firstCoordinate = coordinates.first {
            let cameraUpdate = NMFCameraUpdate(scrollTo: firstCoordinate)
            cameraUpdate.animation = .easeIn
            uiView.moveCamera(cameraUpdate)
        }
    }
}
