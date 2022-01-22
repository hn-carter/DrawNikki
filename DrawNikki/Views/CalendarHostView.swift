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

        VStack {
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
                        Button(action: {selectedDate = data.date}) {
                            Text("00")
                                .padding(18)
                                .foregroundColor(.clear)
                                .background(
                                    nikkiManager.appCalendar.isDate(data.date, inSameDayAs: selectedDate) ? Color.red
                                    : nikkiManager.appCalendar.isDateInToday(data.date) ? .green
                                    : .blue
                                )
                                .cornerRadius(8)
                                .accessibilityHidden(true)
                                .overlay(
                                    VStack {
                                        Text(dayFormatter.string(from: data.date))
                                            .foregroundColor(.white)
                                        if data.picture == nil {
                                            Image(systemName: "square.and.pencil")
                                                .resizable()
                                                .padding()
                                        } else {
                                            Image(uiImage: data.picture!)
                                                .resizable()
                                                .scaledToFit()
                                                .padding()
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
}

struct CalendarHostView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarHostView()
    }
}
