//
//  CalenderView.swift
//  TestProject
//
//  Created by 황상환 on 9/6/24.
//

import SwiftUI

struct CalenderView: View {
    @State private var month: Date = Date()
    @State private var offset: CGSize = CGSize()
    @State private var selectedDate: Date? = nil
    @State private var monthlyRunningData: [Date: HealthKitManager.WeeklyRunningData] = [:]
    @State private var showingRunningData = false
    // 특정 날짜의 데이터를 받아오기
    @State private var isLoadingData = false
    
    let healthKitManager = HealthKitManager.shared
    
    var body: some View {
        VStack {
            headerView
            calendarGridView
        }
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    self.offset = gesture.translation
                }
                .onEnded { gesture in
                    if gesture.translation.width < -100 {
                        changeMonth(by: 1)
                    } else if gesture.translation.width > 100 {
                        changeMonth(by: -1)
                    }
                    self.offset = CGSize()
                }
        )
        .padding()
        .onAppear {
            loadMonthData()
        }
        .sheet(isPresented: $showingRunningData) {
            RunningDataSheet(
                selectedDate: selectedDate,
                monthlyRunningData: monthlyRunningData,
                isLoadingData: isLoadingData,
                onReload: loadMonthData
            )
        }
        .onChange(of: month) { oldValue, newValue in
            loadMonthData()
        }
    }
    
    private func loadMonthData() {
        isLoadingData = true // 로딩 상태 추가
        
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: month))!
        let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
        
        healthKitManager.fetchRunningDataForDateRange(start: startOfMonth, end: endOfMonth) { data in
            DispatchQueue.main.async {
                let dataDict = Dictionary(grouping: data) { item in
                    Calendar.current.startOfDay(for: item.date)
                }.mapValues { $0.first! }
                
                self.monthlyRunningData = dataDict
                self.isLoadingData = false // 로딩 완료
            }
        }
    }
    
    // MARK: - 날짜 그리드 뷰
    private var calendarGridView: some View {
        let daysInMonth: Int = numberOfDays(in: month)
        let firstWeekday: Int = firstWeekdayOfMonth(in: month) - 1
        let days = 0..<(daysInMonth + firstWeekday)

        return VStack {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(days, id: \.self) { index in
                    if index < firstWeekday {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(Color.clear)
                    } else {
                        let date = getDate(for: index - firstWeekday)
                        let day = index - firstWeekday + 1
                        let hasRunningData = monthlyRunningData[date] != nil
                        
                        CellView(day: day,
                                 hasRunningData: hasRunningData,
                                 isSelected: selectedDate != nil && Calendar.current.isDate(date, inSameDayAs: selectedDate!))
                        .onTapGesture {
                            if hasRunningData {
                                selectedDate = date
                                // 데이터가 실제로 있는지 한번 더 확인
                                if monthlyRunningData[date] != nil {
                                    showingRunningData = true
                                } else {
                                    loadMonthData() // 데이터가 없다면 다시 로드
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - 일자 셀 뷰
private struct CellView: View {
    var day: Int
    var hasRunningData: Bool
    var isSelected: Bool
    
    var body: some View {
        VStack {
            Text(String(day))
                .foregroundColor(textColor)
                .padding(5)
                .background(isSelected ? Color.black.opacity(0.2) : Color.clear)
                .font(.custom("DungGeunMo", size: 18))
                .clipShape(Circle())
        }
    }
    
    private var textColor: Color {
        if isSelected {
            return .black
        } else if hasRunningData {
            return .black
        } else {
            return Color.gray.opacity(0.6)
        }
    }
}

// MARK: - 내부 메서드
private extension CalenderView {
    /// 특정 해당 날짜
    private func getDate(for day: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: day, to: startOfMonth())!
    }
  
    /// 해당 월의 시작 날짜
    func startOfMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: month)
        return Calendar.current.date(from: components)!
    }
  
    /// 해당 월에 존재하는 일자 수
    func numberOfDays(in date: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
    }
  
    /// 해당 월의 첫 날짜가 갖는 해당 주의 몇번째 요일
    func firstWeekdayOfMonth(in date: Date) -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        
        return Calendar.current.component(.weekday, from: firstDayOfMonth)
    }
  
    /// 월 변경
    func changeMonth(by value: Int) {
        let calendar = Calendar.current
        if let newMonth = calendar.date(byAdding: .month, value: value, to: month) {
            withAnimation {
                self.month = newMonth
            }
        }
    }
}

// MARK: - Static 프로퍼티
extension CalenderView {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
  
    static let weekdaySymbols = Calendar.current.veryShortWeekdaySymbols
}

// MARK: - CalenderView Extension for HeaderView
extension CalenderView {
    var headerView: some View {
        VStack {
            HStack {
                Button(action: {
                    changeMonth(by: -1)
                }) {
                    Image(systemName: "chevron.left")
                        .padding()
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Text(month, formatter: Self.dateFormatter)
                    .font(.custom("DungGeunMo", size: 20))
                
                Spacer()
                
                Button(action: {
                    changeMonth(by: 1)
                }) {
                    Image(systemName: "chevron.right")
                        .padding()
                        .foregroundColor(.black)
                }
            }
            
            HStack {
                ForEach(Self.weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .frame(maxWidth: .infinity)
                        .font(.custom("DungGeunMo", size: 15))

                }
            }
            .padding(.bottom, 5)
        }
    }
}

// 시트용 별도 뷰 컴포넌트
struct RunningDataSheet: View {
    let selectedDate: Date?
    let monthlyRunningData: [Date: HealthKitManager.WeeklyRunningData]
    let isLoadingData: Bool
    let onReload: () -> Void
    
    var body: some View {
        Group {
            if let date = selectedDate,
               let data = monthlyRunningData[date] {
                SelectedDateRunningView(
                    date: date,
                    runningData: data
                )
            } else {
                ProgressView()
                    .onAppear {
                        if !isLoadingData {
                            onReload()
                        }
                    }
            }
        }
    }
}

#Preview {
    CalenderView()
}


