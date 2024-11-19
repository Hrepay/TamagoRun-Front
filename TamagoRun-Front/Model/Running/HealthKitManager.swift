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
    
    // 필요한 모든 데이터 타입을 한 번에 정의
    private let typesToShare: Set = [
        HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
        HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
        HKQuantityType.quantityType(forIdentifier: .runningSpeed)!,
        HKObjectType.workoutType()
    ]
    
    private let typesToRead: Set = [
        HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
        HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
        HKQuantityType.quantityType(forIdentifier: .runningSpeed)!,
        HKObjectType.workoutType()
    ]
    
    // 권한 요청 함수 수정
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        // 먼저 권한 상태 확인
        let authorizationStatus = typesToShare.map { healthStore.authorizationStatus(for: $0) }
        
        // 이미 모든 권한이 있는지 확인
        if authorizationStatus.allSatisfy({ $0 == .sharingAuthorized }) {
            completion(true, nil)
            return
        }
        
        // 권한 요청
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
            DispatchQueue.main.async {
                completion(success, error)
            }
        }
    }
    
    // 데이터 저장 함수 수정
    func saveRunningWorkout(distance: Double, time: TimeInterval, calories: Double, pace: Double, completion: @escaping (Bool, Error?) -> Void) {
        // 권한 상태 다시 확인
        let authorizationStatus = typesToShare.map { healthStore.authorizationStatus(for: $0) }
        
        // 모든 필요한 권한이 있는지 확인
        guard authorizationStatus.allSatisfy({ $0 == .sharingAuthorized }) else {
            // 권한이 없으면 다시 요청
            requestAuthorization { [weak self] success, error in
                guard let self = self, success else {
                    completion(false, error)
                    return
                }
                // 권한 획득 후 저장 시도
                self.performWorkoutSave(distance: distance, time: time, calories: calories, pace: pace, completion: completion)
            }
            return
        }
        
        // 권한이 있으면 바로 저장
        performWorkoutSave(distance: distance, time: time, calories: calories, pace: pace, completion: completion)
    }
}

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
    
    private func performWorkoutSave(distance: Double, time: TimeInterval, calories: Double, pace: Double, completion: @escaping (Bool, Error?) -> Void) {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .running
        
        let workoutBuilder = HKWorkoutBuilder(healthStore: healthStore, configuration: configuration, device: .local())
        
        let startDate = Date().addingTimeInterval(-time)
        let endDate = Date()
        
        workoutBuilder.beginCollection(withStart: startDate) { success, error in
            if !success {
                completion(false, error)
                return
            }
            
            // 거리 데이터
            let distanceQuantity = HKQuantity(unit: HKUnit.meter(), doubleValue: distance)
            let distanceSample = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                quantity: distanceQuantity,
                start: startDate,
                end: endDate
            )
            
            // 칼로리 데이터
            let energyQuantity = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: calories)
            let energySample = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
                quantity: energyQuantity,
                start: startDate,
                end: endDate
            )
            
            // 속도 데이터
            let speedInMetersPerSecond = 1000 / (pace * 60)
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
            
            // 모든 샘플을 한번에 추가
            workoutBuilder.add([distanceSample, energySample, speedSample]) { success, error in
                if !success {
                    completion(false, error)
                    return
                }
                
                workoutBuilder.endCollection(withEnd: endDate) { success, error in
                    if !success {
                        completion(false, error)
                        return
                    }
                    
                    workoutBuilder.finishWorkout { workout, error in
                        DispatchQueue.main.async {
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
            let runningData = workouts.map { [self] workout in
                let data = self.processWorkout(workout)
                return WeeklyRunningData(
                    date: workout.startDate,
                    distance: data.distance,
                    calories: data.calories,
                    duration: data.duration,
                    pace: data.pace
                )
            }
            
            DispatchQueue.main.async {
                completion(runningData)
            }
        }
        
        healthStore.execute(query)
    }
}

// 월 통계
// HealthKitManager.swift
extension HealthKitManager {
    struct MonthlyRunningData {
        let date: Date
        let distance: Double
        let calories: Double
        let duration: TimeInterval
        let pace: Double
    }
    
    // 페이스 계산을 위한 헬퍼 메서드
    private func calculatePace(duration: TimeInterval, distance: Double) -> Double {
        if distance > 0 {
            return (duration / 60 / distance) / 2  // 분/km
        }
        return 0
    }
    
    func fetchMonthlyRunningStats(forYear year: Int = Calendar.current.component(.year, from: Date()), completion: @escaping ([MonthlyRunningData]) -> Void) {
        let calendar = Calendar.current
        
        guard let startOfYear = calendar.date(from: DateComponents(year: year, month: 1, day: 1)),
              let endOfYear = calendar.date(from: DateComponents(year: year, month: 12, day: 31)) else {
            completion([])
            return
        }
        
        let workoutType = HKObjectType.workoutType()
        let predicate = HKQuery.predicateForWorkouts(with: .running)
        let datePredicate = HKQuery.predicateForSamples(withStart: startOfYear, end: endOfYear, options: .strictStartDate)
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
            
            let runningData = workouts.map { [self] workout in
                let data = self.processWorkout(workout)
                return MonthlyRunningData(
                    date: workout.startDate,
                    distance: data.distance,
                    calories: data.calories,
                    duration: data.duration,
                    pace: data.pace
                )
            }
            
            DispatchQueue.main.async {
                completion(runningData)
            }
        }
        
        healthStore.execute(query)
    }
}

// HealthKitManager Extension
extension HealthKitManager {
    func fetchRunningDataForDateRange(start: Date, end: Date, completion: @escaping ([WeeklyRunningData]) -> Void) {
        let workoutType = HKObjectType.workoutType()
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            HKQuery.predicateForWorkouts(with: .running),
            HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        ])
        
        let query = HKSampleQuery(
            sampleType: workoutType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)]
        ) { (_, samples, error) in
            guard let workouts = samples as? [HKWorkout], error == nil else {
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }
            
            let runningData = workouts.map { workout in
                WeeklyRunningData(
                    date: workout.startDate,
                    distance: (workout.totalDistance?.doubleValue(for: .meter()) ?? 0) / 1000,
                    calories: workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0,
                    duration: workout.duration,
                    pace: (workout.duration / 60) / ((workout.totalDistance?.doubleValue(for: .meter()) ?? 1) / 1000)
                )
            }
            
            DispatchQueue.main.async {
                completion(runningData)
            }
        }
        
        healthStore.execute(query)
    }
}

extension HealthKitManager {
    // 공통으로 사용할 헬퍼 메서드들
    private func convertToKilometers(_ meters: Double) -> Double {
        return meters / 1000.0
    }
    
    private func calculatePace(duration: TimeInterval, distanceInKm: Double) -> Double {
        if distanceInKm > 0 {
            return duration / 60 / distanceInKm  // 분/km
        }
        return 0
    }
    
    private func processWorkout(_ workout: HKWorkout) -> (distance: Double, calories: Double, duration: TimeInterval, pace: Double) {
        let distanceInMeters = workout.totalDistance?.doubleValue(for: .meter()) ?? 0
        let distanceInKm = convertToKilometers(distanceInMeters)
        let calories = workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0
        let duration = workout.duration
        let pace = calculatePace(duration: duration, distanceInKm: distanceInKm)
        
        return (distanceInKm, calories, duration, pace)
    }
}
