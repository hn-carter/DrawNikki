//
//  CalendarHostView.swift
//  DrawNikki
//
//  Created by hn-carter on 2022/01/16.
//

import SwiftUI
import os

struct CalendarHostView: View {

    let logger = Logger(subsystem: "DrawNikki.CalendarHostView", category: "CalendarHostView")
    
    @EnvironmentObject var nikkiManager: NikkiManager
    
    @StateObject var nikki: NikkiViewModel
    
    // 画面の向きを設定
    @State private var orientation = UIDeviceOrientation.unknown

    // 選択された日
    @State private var selectedDate = Self.now
    private static var now = Date()
    
    var body: some View {
        // DateFormatter : 日付のフォーマット
        // タイトル（表示している年月）
        let yearFormatter = DateFormatter(dateFormat: "y", calendar: nikkiManager.appCalendar)
        let monthFormatter = DateFormatter(dateFormat: "MMMM", calendar: nikkiManager.appCalendar)
        // 通常の日
        let dayFormatter = DateFormatter(dateFormat: "d", calendar: nikkiManager.appCalendar)
        // ヘッダ（曜日を表す）
        let weekDayFormatter = DateFormatter(dateFormat: "E", calendar: nikkiManager.appCalendar)
        
        let cellWidth = UIScreen.main.bounds.width / 7.0
        let cellHeight = max(100.0, UIScreen.main.bounds.height / 9.0)
        logger.debug("cellWidth = \(cellWidth), cellHeight = \(cellHeight)")
        logger.debug("languageCode = \(Locale.current.languageCode!), regionCode = \(Locale.current.regionCode!)")

        return VStack {
            //　回転の向き確認用
            if orientation.isPortrait {
                Text("Portrait")
                    .foregroundColor(Color.black.opacity(0.1))
            } else if orientation.isLandscape {
                Text("Landscape")
                    .foregroundColor(Color.black.opacity(0.1))
            } else if orientation.isFlat {
                Text("Flat")
                    .foregroundColor(Color.black.opacity(0.1))
            } else {
                Text("Unknown")
                    .foregroundColor(Color.black.opacity(0.1))
            }

            Text("選択日付 : \(selectedDate.toString())")
                .font(.title)
            ScrollView {
                CalendarView(
                    date: $selectedDate,
                    title: { date in
                        HStack{
                            // 前月
                            Button {
                                withAnimation {
                                    guard let newDate = nikkiManager.appCalendar.date(
                                        byAdding: .month,
                                        value: -1,
                                        to: selectedDate
                                    ) else {
                                        return
                                    }

                                    selectedDate = newDate
                                }
                            } label: {
                                Label(
                                    title: { Text("Previous") },
                                    icon: { Image(systemName: "chevron.left") }
                                )
                                .labelStyle(IconOnlyLabelStyle())
                                .padding(.horizontal)
                                .frame(maxHeight: .infinity)
                            }
                            // 表示年月
                            if Locale.current.languageCode == "ja" {
                                Text("\(yearFormatter.string(from: date))年 ")
                                    .font(.largeTitle)
                                    .padding()
                            }
                            Text(monthFormatter.string(from: date))
                                .font(.largeTitle)
                                .padding()
                            if Locale.current.languageCode != "ja" {
                                Text(yearFormatter.string(from: date))
                                    .font(.largeTitle)
                                    .padding()
                            }
                            //翌月へ移動ボタン
                            Button {
                                withAnimation {
                                    guard let newDate = nikkiManager.appCalendar.date(
                                        byAdding: .month,
                                        value: 1,
                                        to: selectedDate
                                    ) else {
                                        return
                                    }

                                    selectedDate = newDate
                                }
                            } label: {
                                Label(
                                    title: { Text("Next") },
                                    icon: { Image(systemName: "chevron.right") }
                                )
                                .labelStyle(IconOnlyLabelStyle())
                                .padding(.horizontal)
                                .frame(maxHeight: .infinity)
                            }
                        }
                        Divider()
                    },
                    header: { date in
                        VStack {
                            if Locale.current.regionCode == "JP" {
                                if nikkiManager.appCalendar.component(.weekday, from: date) == 1 {
                                    // 日曜日
                                    Text(weekDayFormatter.string(from: date))
                                        .font(.title)
                                        .foregroundColor(Color.red)
                                } else if nikkiManager.appCalendar.component(.weekday, from: date) == 7 {
                                    // 土曜日
                                    Text(weekDayFormatter.string(from: date))
                                        .font(.title)
                                        .foregroundColor(Color.blue)
                                } else {
                                    Text(weekDayFormatter.string(from: date))
                                        .font(.title)
                                }
                            } else {
                                if nikkiManager.appCalendar.component(.weekday, from: date) == 1 {
                                    // 日曜日
                                    Text(weekDayFormatter.string(from: date))
                                        .font(.title)
                                        .foregroundColor(Color.red)
                                } else {
                                    Text(weekDayFormatter.string(from: date))
                                        .font(.title)
                                }
                            }
                        }
                    },
                    days: { data in
                        let bgColor: Color = getBackColor(page: data)
                        let fgColor: Color = getForeColor(color: bgColor)
                        
                        Button(action: {
                            selectedDate = data.date
                            // 詳細画面へ遷移
                            nikki.setPage(date: selectedDate)
                            nikki.selectionTab = 1
                        }) {
                            let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
                            if orientation == .portrait ||
                                orientation == .portraitUpsideDown {
                                Text("00")
                                    .frame(maxWidth: .infinity, minHeight: cellHeight)
                                    .foregroundColor(.clear)
                                    .background(bgColor)
                                    .cornerRadius(8)
                                    .accessibilityHidden(true)
                                    .overlay(
                                    VStack {
                                        Text(dayFormatter.string(from: data.date))
                                            .font(.headline)
                                            .foregroundColor(fgColor)
                                            //.padding(.bottom, 0)
                                        if data.picture == nil {
                                            Image(systemName: "square.and.pencil")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: cellWidth)
                                        } else {
                                            Image(uiImage: data.picture!)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: cellWidth - 8.0)
                                        }
                                    }
                                )
                            } else {
                                Text("00")
                                    .frame(maxWidth: .infinity, minHeight: cellHeight)
                                    .foregroundColor(.clear)
                                    .background(bgColor)
                                    .cornerRadius(8)
                                    .accessibilityHidden(true)
                                    .overlay(
                                        HStack {
                                            Text(dayFormatter.string(from: data.date))
                                                .font(.headline)
                                                .foregroundColor(fgColor)
                                                //.padding(.trailing, 0)
                                            if data.picture == nil {
                                                Image(systemName: "square.and.pencil")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: cellHeight)
                                            } else {
                                                Image(uiImage: data.picture!)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: cellHeight - 8.0)
                                            }
                                        }
                                    )
                            }
                        }
                    },
                    trailing: { data in
                        Text(dayFormatter.string(from: data.date))
                            .foregroundColor(.secondary)
                    })
                
            }
        }
        // 回転時のイベント (カスタムモディファイア)
        .onRotate { newOrientation in
            orientation = newOrientation
        }
    }
    
    
    func getBackColor(page: NikkiPage) -> Color {
        if nikkiManager.appCalendar.isDate(page.date, inSameDayAs: selectedDate) {
            return nikkiManager.calendarCellColorSelected
        } else if nikkiManager.appCalendar.isDateInToday(page.date) {
            return nikkiManager.calendarCellColorToday
        } else if page.isHighlight {
            // 祭日
            return nikkiManager.calendarCellColorHighlight
        } else if nikkiManager.appCalendar.component(.weekday, from: page.date) == 1 {
            return nikkiManager.calendarCellColorSun
        } else if nikkiManager.appCalendar.component(.weekday, from: page.date) == 2 {
            return nikkiManager.calendarCellColorMon
        } else if nikkiManager.appCalendar.component(.weekday, from: page.date) == 3 {
            return nikkiManager.calendarCellColorTue
        } else if nikkiManager.appCalendar.component(.weekday, from: page.date) == 4 {
            return nikkiManager.calendarCellColorWed
        } else if nikkiManager.appCalendar.component(.weekday, from: page.date) == 5 {
            return nikkiManager.calendarCellColorThu
        } else if nikkiManager.appCalendar.component(.weekday, from: page.date) == 6 {
            return nikkiManager.calendarCellColorFri
        } else if nikkiManager.appCalendar.component(.weekday, from: page.date) == 7 {
            return nikkiManager.calendarCellColorSat
        }
        return Color.white
    }
    
    func getForeColor(color: Color) -> Color {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        UIColor(color).getRed(&red, green: &green, blue: &blue, alpha: nil)

        let lightRed = red > 0.65
        let lightGreen = green > 0.65
        let lightBlue = blue > 0.65

        let lightness = [lightRed, lightGreen, lightBlue].reduce(0) { $1 ? $0 + 1 : $0 }
        if lightness >= 2 {
            return Color.black
        }
        return Color.white
    }
}

struct CalendarHostView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarHostView(nikki: NikkiViewModel())
    }
}
