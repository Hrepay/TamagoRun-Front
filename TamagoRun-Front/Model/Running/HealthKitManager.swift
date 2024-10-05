//
//  HealthKitManager.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 9/24/24.
//

import Foundation
import HealthKit

class HealthKitManager {
    static let shared = HealthKitManager()
    let healthStore = HKHealthStore()
    
    // HealthKit 권한 확인
    func checkAuthorizationStatus() -> Bool {
        // HealthKit 사용 가능 여부 확인
        guard HKHealthStore.isHealthDataAvailable() else { return false }
        
        // 읽을 데이터 타입 정의 (예: 걷기/달리기 거리, 소모 칼로리, 운동 유형)
        let typesToRead: Set = [
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.workoutType()
        ]
        
        // 각 데이터 타입의 권한 상태를 확인
        for type in typesToRead {
            let status = healthStore.authorizationStatus(for: type)
            if status != .sharingAuthorized {
                // 권한이 부여되지 않은 경우 false 반환
                return false
            }
        }
        return true // 모든 권한이 부여된 경우 true 반환
    }
    
    // HealthKit 권한 요청
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        // 저장할 데이터 타입 (거리, 시간, 칼로리)
        guard let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning),
              let energyType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
            completion(false, nil)
            return
        }

        let workoutType = HKObjectType.workoutType()

        // 공유할 데이터와 읽을 데이터 타입 설정
        let typesToShare: Set = [distanceType, energyType, workoutType]
        let typesToRead: Set = [distanceType, energyType, workoutType]

        // HealthKit 권한 요청
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
            DispatchQueue.main.async {
                if success {
                    print("HealthKit 권한 요청 성공")
                } else {
                    print("HealthKit 권한 요청 실패: \(String(describing: error?.localizedDescription))")
                }
                completion(success, error)
            }
        }
    }
}


// HealthKitManager의 확장 기능
extension HealthKitManager {

    func saveRunningData(distance: Double, time: TimeInterval, calories: Double, completion: @escaping (Bool, Error?) -> Void) {
        // Workout Configuration 설정
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .running

        // Workout Builder 생성
        let workoutBuilder = HKWorkoutBuilder(healthStore: healthStore, configuration: configuration, device: .local())

        // 운동 시작 시간을 현재 시점으로 설정
        let startDate = Date()

        // Workout Builder 세션 시작
        workoutBuilder.beginCollection(withStart: startDate) { (success, error) in
            if !success {
                completion(false, error)
                return
            }

            // 거리 데이터 생성
            let distanceQuantity = HKQuantity(unit: HKUnit.meter(), doubleValue: distance)
            let distanceSample = HKQuantitySample(type: HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!, quantity: distanceQuantity, start: startDate, end: startDate.addingTimeInterval(time))

            // 칼로리 데이터 생성
            let energyQuantity = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: calories)
            let energySample = HKQuantitySample(type: HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!, quantity: energyQuantity, start: startDate, end: startDate.addingTimeInterval(time))

            // Workout Builder에 샘플 추가
            workoutBuilder.add([distanceSample, energySample]) { (success, error) in
                if !success {
                    completion(false, error)
                    return
                }

                // 운동 종료 시간을 운동 시간 후로 설정
                let endDate = startDate.addingTimeInterval(time)
                
                // Workout 세션 종료 및 저장
                workoutBuilder.endCollection(withEnd: endDate) { (success, error) in
                    if !success {
                        completion(false, error)
                        return
                    }

                    // Workout을 생성하고 저장
                    workoutBuilder.finishWorkout { (workout, error) in
                        if let error = error {
                            completion(false, error)
                        } else {
                            completion(true, nil)
                        }
                    }
                }
            }
        }
    }
}

// HealthKitManager의 데이터 불러오기 기능 확장
extension HealthKitManager {
    // 거리, 칼로리, 시간 데이터 가져오기
    func fetchRunningData(completion: @escaping (Double, Double, TimeInterval) -> Void) {
        let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
        let energyType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        let workoutType = HKObjectType.workoutType()

        // 거리 쿼리
        let distanceQuery = HKStatisticsQuery(quantityType: distanceType, quantitySamplePredicate: nil, options: .cumulativeSum) { _, result, _ in
            let distance = result?.sumQuantity()?.doubleValue(for: HKUnit.meter()) ?? 0
            
            // 칼로리 쿼리
            let energyQuery = HKStatisticsQuery(quantityType: energyType, quantitySamplePredicate: nil, options: .cumulativeSum) { _, result, _ in
                let calories = result?.sumQuantity()?.doubleValue(for: HKUnit.kilocalorie()) ?? 0
                
                // 운동 시간 쿼리
                let workoutPredicate = HKQuery.predicateForWorkouts(with: .running)
                let workoutQuery = HKSampleQuery(sampleType: workoutType, predicate: workoutPredicate, limit: 0, sortDescriptors: nil) { (_, samples, _) in
                    var totalTime: TimeInterval = 0
                    
                    if let workouts = samples as? [HKWorkout] {
                        totalTime = workouts.reduce(0) { $0 + $1.duration }
                    }
                    
                    // 메인 쓰레드에서 업데이트
                    DispatchQueue.main.async {
                        completion(distance, calories, totalTime)
                    }
                }
                
                self.healthStore.execute(workoutQuery)
            }
            self.healthStore.execute(energyQuery)
        }
        healthStore.execute(distanceQuery)
    }
}

extension HealthKitManager {
    // 주간 러닝 데이터를 가져오는 메서드
    func fetchWeeklyRunningData(completion: @escaping ([Bool]) -> Void) {
        // 현재 날짜를 기준으로 일주일 전 월요일부터 일요일까지를 확인
        var runningData: [Bool] = Array(repeating: false, count: 7) // 초기값은 false로 설정
        
        let calendar = Calendar.current
        let now = Date()
        
        // 현재 주의 시작일을 구함 (월요일부터 시작)
        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)) else {
            completion(runningData)
            return
        }
        
//        let endDate = calendar.date(byAdding: .day, value: 7, to: startOfWeek) ?? now

        // `fetchRunningWorkouts` 메서드로 러닝 기록만 가져오기
        self.fetchRunningWorkouts { workouts in
            // 각 운동 기록의 날짜를 분석하여 주간 데이터에 반영
            for workout in workouts {
                let workoutDate = workout.startDate
                
                if calendar.isDate(workoutDate, inSameDayAs: startOfWeek) {
                    runningData[0] = true
                } else if let index = calendar.dateComponents([.day], from: startOfWeek, to: workoutDate).day, index >= 0, index < 7 {
                    runningData[index] = true
                }
            }
            
            DispatchQueue.main.async {
                completion(runningData)
            }
        }
    }
}

extension HealthKitManager {
    // 러닝 운동 기록만 가져오는 메서드
    func fetchRunningWorkouts(completion: @escaping ([HKWorkout]) -> Void) {
        let workoutType = HKObjectType.workoutType()
        
        // 운동 타입이 러닝인 경우에 대한 필터
        let predicate = HKQuery.predicateForWorkouts(with: .running)

        let query = HKSampleQuery(sampleType: workoutType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
            guard let workouts = samples as? [HKWorkout], error == nil else {
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }
            
            // 메인 쓰레드에서 러닝 운동 기록을 반환
            DispatchQueue.main.async {
                completion(workouts)
            }
        }

        healthStore.execute(query)
    }
}

extension HealthKitManager {
    func saveRunningWorkout(distance: Double, time: TimeInterval, calories: Double, pace: Double, completion: @escaping (Bool, Error?) -> Void) {
        // Workout Configuration 설정
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .running

        // Workout Builder 생성
        let workoutBuilder = HKWorkoutBuilder(healthStore: healthStore, configuration: configuration, device: .local())

        // 운동 시작 시간을 현재 시점에서 운동 시간만큼 뺀 시점으로 설정
        let startDate = Date().addingTimeInterval(-time)
        let endDate = Date()

        // Workout Builder 세션 시작
        workoutBuilder.beginCollection(withStart: startDate) { (success, error) in
            if !success {
                completion(false, error)
                return
            }

            // 거리 데이터 생성
            let distanceQuantity = HKQuantity(unit: HKUnit.meter(), doubleValue: distance)
            let distanceSample = HKQuantitySample(type: HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!, quantity: distanceQuantity, start: startDate, end: endDate)

            // 칼로리 데이터 생성
            let energyQuantity = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: calories)
            let energySample = HKQuantitySample(type: HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!, quantity: energyQuantity, start: startDate, end: endDate)

            // 페이스 데이터 생성 (초/미터 단위로 변환)
            let paceQuantity = HKQuantity(unit: HKUnit.second().unitDivided(by: .meter()), doubleValue: pace / 60.0)
            let paceSample = HKQuantitySample(type: HKQuantityType.quantityType(forIdentifier: .runningSpeed)!, quantity: paceQuantity, start: startDate, end: endDate)

            // Workout Builder에 샘플 추가
            workoutBuilder.add([distanceSample, energySample, paceSample]) { (success, error) in
                if !success {
                    completion(false, error)
                    return
                }

                // Workout 세션 종료 및 저장
                workoutBuilder.endCollection(withEnd: endDate) { (success, error) in
                    if !success {
                        completion(false, error)
                        return
                    }

                    // Workout을 생성하고 저장
                    workoutBuilder.finishWorkout { (workout, error) in
                        if let error = error {
                            completion(false, error)
                        } else {
                            completion(true, nil)
                        }
                    }
                }
            }
        }
    }
}
