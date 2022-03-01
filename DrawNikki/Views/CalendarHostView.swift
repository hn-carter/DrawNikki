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

    // 画面で使用するViewModel
    @State private var calVM: CalendarViewModel = CalendarViewModel()

    // カレンダーの日付セルの表示間隔
    private let cellSpacer: CGFloat = 2.0
    
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

            //Text("選択日付 : \(nikki.selectedDate.toString())")
            //    .font(.title)
                CalendarView(
                    date: $nikki.selectedDate,
                    calVM: $calVM,
                    title: { date in
                        HStack{
                            // 前月
                            Button {
                                withAnimation {
                                    guard let newDate = nikkiManager.appCalendar.date(
                                        byAdding: .month,
                                        value: -1,
                                        to: nikki.selectedDate
                                    ) else {
                                        return
                                    }

                                    nikki.selectedDate = newDate
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
                                    .font(.title)
                                    .padding()
                            }
                            Text(monthFormatter.string(from: date))
                                .font(.title)
                                .padding()
                            if Locale.current.languageCode != "ja" {
                                Text(yearFormatter.string(from: date))
                                    .font(.title)
                                    .padding()
                            }
                            //翌月へ移動ボタン
                            Button {
                                withAnimation {
                                    guard let newDate = nikkiManager.appCalendar.date(
                                        byAdding: .month,
                                        value: 1,
                                        to: nikki.selectedDate
                                    ) else {
                                        return
                                    }

                                    nikki.selectedDate = newDate
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
                    },  // End of title
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
                        .frame(width: cellWidth)
                    }, // End of header
                    days: { data in
                        let bgColor: Color = getBackColor(page: data)
                        let fgColor: Color = getForeColor(color: bgColor)
                        
                        Button(action: {
                            // 選択日付をセット
                            nikki.selectedDate = data.date
                            // 詳細画面へ遷移
                            nikki.selectionTab = 1
                        }) {
                            let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
                            if orientation == .portrait ||
                                orientation == .portraitUpsideDown {
                                Text("00")
                                    .frame(maxWidth: cellWidth-cellSpacer, minHeight: cellHeight-cellSpacer)
                                    .foregroundColor(.clear)
                                    .background(bgColor)
                                    .cornerRadius(8)
                                    .frame(maxWidth: cellWidth, minHeight: cellHeight)
                                    .accessibilityHidden(true)
                                    .overlay(
                                    VStack {
                                        Text(dayFormatter.string(from: data.date))
                                            .font(.headline)
                                            .foregroundColor(fgColor)
                                            .padding(.top, 3.0)
                                        if data.picture == nil {
                                            Image(systemName: "square.and.pencil")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: cellWidth - 20.0)
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
                                    .frame(maxWidth: cellWidth-cellSpacer, minHeight: cellHeight-cellSpacer)
                                    .foregroundColor(.clear)
                                    .background(bgColor)
                                    .cornerRadius(8)
                                    .frame(maxWidth: cellWidth, minHeight: cellHeight)
                                    .accessibilityHidden(true)
                                    .overlay(
                                        HStack {
                                            Text(dayFormatter.string(from: data.date))
                                                .font(.headline)
                                                .foregroundColor(fgColor)
                                                .padding(.leading, 3.0)
                                            if data.picture == nil {
                                                Image(systemName: "square.and.pencil")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: cellHeight - 8.0)
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
                    },  // End of days
                    trailing: { data in
                        Text(dayFormatter.string(from: data.date))
                            .frame(maxWidth: cellWidth, minHeight: cellHeight)
                            .foregroundColor(.secondary)
                    })  // End of trailing
        }
        .onAppear {
            logger.trace("CalendarHostView.onAppear")
        }
        // 回転時のイベント (カスタムモディファイア)
        .onRotate { newOrientation in
            orientation = newOrientation
        }
    }
    
    /// 日付の背景色を返す
    /// - Parameter page: 表示データ
    /// - Returns: 表示背景色
    func getBackColor(page: NikkiPage) -> Color {
        if nikkiManager.appCalendar.isDate(page.date, inSameDayAs: nikki.selectedDate) {
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
    
    /// 背景色から文字の前景色を返す
    /// - Parameter color: 背景色
    /// - Returns: 表示前景色
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
