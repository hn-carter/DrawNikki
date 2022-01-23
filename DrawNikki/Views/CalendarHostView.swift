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

    // 選択された日
    @State private var selectedDate = Self.now
    private static var now = Date()

    var body: some View {
        // DateFormatter : 日付のフォーマット
        // タイトル（表示している年月）
        let monthFormatter = DateFormatter(dateFormat: "MMMM", calendar: nikkiManager.appCalendar)
        // 通常の日
        let dayFormatter = DateFormatter(dateFormat: "d", calendar: nikkiManager.appCalendar)
        // ヘッダ（曜日を表す）
        let weekDayFormatter = DateFormatter(dateFormat: "E", calendar: nikkiManager.appCalendar)
        
        let cellWidth = UIScreen.main.bounds.width / 7.0
        let cellHeight = UIScreen.main.bounds.width / 9.0
        logger.debug("cellWidth = \(cellWidth), cellHeight = \(cellHeight)")

        return VStack {
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
                            Text(monthFormatter.string(from: date))
                                .font(.headline)
                                .padding()
                            
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
                    },
                    header: { date in
                        Text(weekDayFormatter.string(from: date))
                    },
                    days: { data in
                        let bgColor: Color = getBackColor(page: data)
                        let fgColor: Color = getForeColor(color: bgColor)
                        
                        Button(action: {selectedDate = data.date}) {
                            Text("00")
                                .frame(maxWidth: .infinity, minHeight: cellHeight)
                                .foregroundColor(.clear)
                                .background(bgColor)
                                .cornerRadius(8)
                                .accessibilityHidden(true)
                                .overlay(
                                    VStack {
                                        Text(dayFormatter.string(from: data.date))
                                            .foregroundColor(fgColor)
                                        if data.picture == nil {
                                            Image(systemName: "square.and.pencil")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: cellWidth)
                                        } else {
                                            Image(uiImage: data.picture!)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width:cellWidth)
                                        }
                                    }
                                )

                        }
                    },
                    trailing: { data in
                        Text(dayFormatter.string(from: data.date))
                            .foregroundColor(.secondary)
                    })
                
            }
        }
    }
    
    
    func getBackColor(page: NikkiPage) -> Color {
        if nikkiManager.appCalendar.isDate(page.date, inSameDayAs: selectedDate) {
            return nikkiManager.calendarCellColorSelected
        } else if nikkiManager.appCalendar.isDateInToday(page.date) {
            return nikkiManager.calendarCellColorToday
        } else if page.isHighlight {
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
        CalendarHostView()
    }
}
