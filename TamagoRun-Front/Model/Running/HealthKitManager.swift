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

//// HealthKitManager의 확장 기능
//extension HealthKitManager {
//
//    func saveRunningData(distance: Double, time: TimeInterval, calories: Double, completion: @escaping (Bool, Error?) -> Void) {
//        // Workout Configuration 설정
//        let configuration = HKWorkoutConfiguration()
//        configuration.activityType = .running
//
//        // Workout Builder 생성
//        let workoutBuilder = HKWorkoutBuilder(healthStore: healthStore, configuration: configuration, device: .local())
//
//        // 운동 시작 시간을 현재 시점으로 설정
//        let startDate = Date()
//
//        // Workout Builder 세션 시작
//        workoutBuilder.beginCollection(withStart: startDate) { (success, error) in
//            if !success {
//                completion(false, error)
//                return
//            }
//
//            // 거리 데이터 생성
//            let distanceQuantity = HKQuantity(unit: HKUnit.meter(), doubleValue: distance)
//            let distanceSample = HKQuantitySample(type: HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!, quantity: distanceQuantity, start: startDate, end: startDate.addingTimeInterval(time))
//
//            // 칼로리 데이터 생성
//            let energyQuantity = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: calories)
//            let energySample = HKQuantitySample(type: HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!, quantity: energyQuantity, start: startDate, end: startDate.addingTimeInterval(time))
//
//            // Workout Builder에 샘플 추가
//            workoutBuilder.add([distanceSample, energySample]) { (success, error) in
//                if !success {
//                    completion(false, error)
//                    return
//                }
//
//                // 운동 종료 시간을 운동 시간 후로 설정
//                let endDate = startDate.addingTimeInterval(time)
//                
//                // Workout 세션 종료 및 저장
//                workoutBuilder.endCollection(withEnd: endDate) { (success, error) in
//                    if !success {
//                        completion(false, error)
//                        return
//                    }
//
//                    // Workout을 생성하고 저장
//                    workoutBuilder.finishWorkout { (workout, error) in
//                        if let error = error {
//                            completion(false, error)
//                        } else {
//                            completion(true, nil)
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
//
//// HealthKitManager의 데이터 불러오기 기능 확장
//extension HealthKitManager {
//    // 거리, 칼로리, 시간 데이터 가져오기
//    func fetchRunningData(completion: @escaping (Double, Double, TimeInterval) -> Void) {
//        let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
//        let energyType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
//        let workoutType = HKObjectType.workoutType()
//
//        // 거리 쿼리
//        let distanceQuery = HKStatisticsQuery(quantityType: distanceType, quantitySamplePredicate: nil, options: .cumulativeSum) { _, result, _ in
//            let distance = result?.sumQuantity()?.doubleValue(for: HKUnit.meter()) ?? 0
//            
//            // 칼로리 쿼리
//            let energyQuery = HKStatisticsQuery(quantityType: energyType, quantitySamplePredicate: nil, options: .cumulativeSum) { _, result, _ in
//                let calories = result?.sumQuantity()?.doubleValue(for: HKUnit.kilocalorie()) ?? 0
//                
//                // 운동 시간 쿼리
//                let workoutPredicate = HKQuery.predicateForWorkouts(with: .running)
//                let workoutQuery = HKSampleQuery(sampleType: workoutType, predicate: workoutPredicate, limit: 0, sortDescriptors: nil) { (_, samples, _) in
//                    var totalTime: TimeInterval = 0
//                    
//                    if let workouts = samples as? [HKWorkout] {
//                        totalTime = workouts.reduce(0) { $0 + $1.duration }
//                    }
//                    
//                    // 메인 쓰레드에서 업데이트
//                    DispatchQueue.main.async {
//                        completion(distance, calories, totalTime)
//                    }
//                }
//                
//                self.healthStore.execute(workoutQuery)
//            }
//            self.healthStore.execute(energyQuery)
//        }
//        healthStore.execute(distanceQuery)
//    }
//}

// 메인 메뉴에서 주간 러닝 데이터 불러오기 ( 새싹 )
extension HealthKitManager {
    /// 주간 러닝 데이터를 가져오는 메서드
    /// - Parameter completion: 각 요일별 운동 여부를 나타내는 Bool 배열을 반환하는 클로저
    func fetchWeeklyRunningData(completion: @escaping ([Bool]) -> Void) {
        let calendar = Calendar.current
        let now = Date()
        var runningData: [Bool] = Array(repeating: false, count: 7)
        
        // 현재 주의 시작일을 구함 (월요일부터 시작)
        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)) else {
            completion(runningData)
            return
        }
        
        let workoutType = HKObjectType.workoutType()
        let predicate = HKQuery.predicateForWorkouts(with: .running)
        
        let query = HKSampleQuery(
            sampleType: workoutType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: nil
        ) { (_, samples, error) in
            guard let workouts = samples as? [HKWorkout], error == nil else {
                DispatchQueue.main.async {
                    completion(runningData)
                }
                return
            }
            
            // 각 운동 기록의 날짜를 분석하여 주간 데이터에 반영
            for workout in workouts {
                if calendar.isDate(workout.startDate, inSameDayAs: startOfWeek) {
                    runningData[0] = true
                } else if let index = calendar.dateComponents([.day], from: startOfWeek, to: workout.startDate).day,
                          index >= 0, index < 7 {
                    runningData[index] = true
                }
            }
            
            DispatchQueue.main.async {
                completion(runningData)
            }
        }
        
        healthStore.execute(query)
    }
}

// 러닝 후 데이터 저장할 때 사용
extension HealthKitManager {
    func saveRunningWorkout(distance: Double, time: TimeInterval, calories: Double, pace: Double, completion: @escaping (Bool, Error?) -> Void) {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .running

        let workoutBuilder = HKWorkoutBuilder(healthStore: healthStore, configuration: configuration, device: .local())
        
        let startDate = Date().addingTimeInterval(-time)
        let endDate = Date()
        
        // Workout Builder 세션 시작
        workoutBuilder.beginCollection(withStart: startDate) { (success, error) in
            if !success {
                completion(false, error)
                return
            }
            
            // 거리 데이터 생성 (미터 단위)
            let distanceQuantity = HKQuantity(unit: HKUnit.meter(), doubleValue: distance)
            let distanceSample = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                quantity: distanceQuantity,
                start: startDate,
                end: endDate
            )
            
            // 칼로리 데이터 생성
            let energyQuantity = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: calories)
            let energySample = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
                quantity: energyQuantity,
                start: startDate,
                end: endDate
            )
            
            // 속도 데이터 생성 (meters per second로 변환)
            // pace는 min/km로 입력받았으므로 m/s로 변환
            let speedInMetersPerSecond = 1000 / (pace * 60) // 1000m / (pace * 60초)
            let speedQuantity = HKQuantity(
                unit: HKUnit.meter().unitDivided(by: HKUnit.second()),
                doubleValue: speedInMetersPerSecond
            )
            let speedSample = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .runningSpeed)!,
                quantity: speedQuantity,
                start: startDate,
                end: endDate
            )
            
            // Workout Builder에 샘플 추가
            workoutBuilder.add([distanceSample, energySample, speedSample]) { (success, error) in
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

// 일주일 통계
extension HealthKitManager {
    struct WeeklyRunningData {
        let date: Date
        let distance: Double
        let calories: Double
        let duration: TimeInterval
        let pace: Double
    }
    
    func fetchWeeklyRunningStats(completion: @escaping ([WeeklyRunningData]) -> Void) {
        var calendar = Calendar.current
        calendar.firstWeekday = 2  // 1은 일요일, 2는 월요일
        let now = Date()
        
        // 현재 주의 시작일을 구함 (월요일부터 시작)
        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)) else {
            completion([])
            return
        }
        
        let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek)!
        
        // HealthKit에서 러닝 데이터 쿼리
        let workoutType = HKObjectType.workoutType()
        let predicate = HKQuery.predicateForWorkouts(with: .running)
        let datePredicate = HKQuery.predicateForSamples(withStart: startOfWeek, end: endOfWeek, options: .strictStartDate)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, datePredicate])
        
        let query = HKSampleQuery(
            sampleType: workoutType,
            predicate: compoundPredicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)]
        ) { (_, samples, error) in
            guard let workouts = samples as? [HKWorkout], error == nil else {
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }
            
            // 워크아웃 데이터를 WeeklyRunningData로 변환
            let runningData = workouts.map { workout in
                WeeklyRunningData(
                    date: workout.startDate,
                    distance: workout.totalDistance?.doubleValue(for: .meter()) ?? 0 / 1000, // 미터를 킬로미터로 변환
                    calories: workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0,
                    duration: workout.duration,
                    pace: (workout.duration / 60) / (workout.totalDistance?.doubleValue(for: .meter()) ?? 1 / 1000) // 분/킬로미터
                )
            }
            
            DispatchQueue.main.async {
                completion(runningData)
            }
        }
        
        healthStore.execute(query)
    }
}
