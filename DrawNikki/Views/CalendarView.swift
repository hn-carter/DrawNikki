//
//  CalendarView.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/11/21.
//

import SwiftUI
import os

struct CalendarView<Title: View, Header: View, Day: View, Trailing: View>: View {
    
    let logger = Logger(subsystem: "DrawNikki.CalendarView", category: "CalendarView")
    
    @EnvironmentObject var nikkiManager: NikkiManager
    //　カレンダーを表示する日付
    @Binding private var date: Date
    private let calVM: CalendarViewModel
    
    // タイトルを表すView
    private let titleView: (Date) -> Title
    // ヘッダを表すView
    private let headerView: (Date) -> Header
    // 日付を表すView
    private let daysView: (NikkiPage) -> Day
    // 対象外の日付を表すView
    private let trailingView: (NikkiPage) -> Trailing
    
    // イニシャライザ
    public init(
        date: Binding<Date>,
        @ViewBuilder title: @escaping (Date) -> Title,
        @ViewBuilder header: @escaping (Date) -> Header,
        @ViewBuilder days: @escaping (NikkiPage) -> Day,
        @ViewBuilder trailing: @escaping (NikkiPage) -> Trailing
    ) {
        self._date = date
        self.titleView = title
        self.headerView = header
        self.daysView = days
        self.trailingView = trailing
        self.calVM = CalendarViewModel()
    }

    
    var body: some View {
        let days = getDays()
        let dayInfo: [NikkiPage] = makeData()
        
        // LazyVGridでカレンダーを表示する 7列で縦方向に配置
        LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
            // Section : Viewに階層を作成
            Section(header: titleView(date)) {
                ForEach(days.prefix(7), id: \.self, content: headerView)
                ForEach(dayInfo, id: \.date) { data in
                    // 表示したい年月と前後の隙間を埋めるViewを選択する
                    if nikkiManager.appCalendar.isDate(data.date, equalTo: date, toGranularity: .month) {
                        daysView(data)
                    } else {
                        trailingView(data)
                    }
                }
            }
        }
    }
    
    /// カレンダーに表示する日付データを返す
    /// - Returns: 表示する日付配列データ
    func makeData() -> [NikkiPage] {
        let year = date.getYear(calendar: nikkiManager.appCalendar)
        let month = date.getMonth(calendar: nikkiManager.appCalendar)
        // カレンダーに表示する日付配列
        let calendarDays = getDays()
        
        logger.debug("getDays() = \(calendarDays.first!.toString()) - \(calendarDays.last!.toString())")
        
        // 対象年月のページを取得
        let pagesInMonth = calVM.getCalendarData(calendar: nikkiManager.appCalendar, year: year, month: month)
        // 画面に表示する日に該当するNikkiPageを作成する
        var result: [NikkiPage] = []
        var pageIdx = 0
        let maxIdx = pagesInMonth.count - 1
        for d in calendarDays {
            if pageIdx <= maxIdx &&
                nikkiManager.appCalendar.isDate(d, equalTo: pagesInMonth[pageIdx].date,
                                                toGranularity: .day) {
                result.append(pagesInMonth[pageIdx])
                // 次の日までインデックスを進める
                while pageIdx <= maxIdx {
                    if pagesInMonth[pageIdx].date != d {
                        break
                    } else {
                        pageIdx += 1
                    }
                }
            } else {
                // 空のページ
                let spacePage = calVM.createEmptyPage(date: d)
                result.append(spacePage)
            }
        }
        return result
    }
    
    /// カレンダーのますを埋める日付を返す
    /// 対象は、表示対象月の1日から月末と前後の月のカレンダーのマスに該当する日付
    /// カレンダーは月曜始まり
    /// - Returns: 日付配列
    func getDays() -> [Date] {
        // カレンダーの開始曜日 nikkiManager.calendarStartingOn : (1:日...7:土)
        // 月の1日から末日までの期間を取得
        guard let monthInterval = nikkiManager.appCalendar.dateInterval(of: .month, for: date)
        else {
            return []
        }
        // 現在年月の1日をDateで取得
        let firstDate = monthInterval.start
        // 1日の曜日を取得 (1:日...7:土)
        let firstWeekday = nikkiManager.appCalendar.component(.weekday, from: firstDate)
        // 週始まりまで何日あるか
        let before = -1 * ((firstWeekday - nikkiManager.calendarStartingOn + 7) % 7)
        // カレンダーの表示開始日
        guard let calendarStartDay = nikkiManager.appCalendar.date(byAdding: .day, value: before, to: firstDate)
        else {
            return []
        }
        
        // 現在年月の月末日をDateで取得
        let lastDate = monthInterval.end
        // 月末日の曜日 1が日曜日7が土曜日
        let lastWeekday = nikkiManager.appCalendar.component(.weekday, from: lastDate)
        // 週終わりまで何日あるか
        let after = (7 - lastWeekday + nikkiManager.calendarStartingOn) % 7
        // カレンダーの表示最終日
        guard let calendarEndDay = nikkiManager.appCalendar.date(byAdding: .day, value: after, to: lastDate)
        else {
            return []
        }
        
        logger.debug("firstDate = \(firstDate.toString()), lastDate = \(lastDate.toString())")
        logger.debug("firstWeekday = \(firstWeekday), lastWeekday = \(lastWeekday)")
        logger.debug("before = \(before), after = \(after)")
        // カレンダーに表示する期間
        let calendarInterval = DateInterval(start: calendarStartDay, end: calendarEndDay)
        
        var dates = [calendarInterval.start]
        // enumerateDates 指定された期間(dateInterval)の日付を処理する
        nikkiManager.appCalendar.enumerateDates(
            startingAfter: calendarInterval.start,
            matching: nikkiManager.appCalendar.dateComponents([.hour, .minute, .second], from: calendarInterval.start),
            matchingPolicy: .nextTime
        ) { date, _, stop in
            guard let date = date else { return }

            guard date < calendarInterval.end else {
                stop = true
                return }

            dates.append(date)
        }
        
        return dates
    }
}
