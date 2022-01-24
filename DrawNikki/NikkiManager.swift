//
//  NikkiManager.swift
//  DrawNikki
//
//  Created by hn-carteron 2021/11/25.
//

import Foundation
import SwiftUI

/**
 アプリの設定項目を管理する
 */
class NikkiManager: ObservableObject {
    
    /// カレンダーで使用する祭日
    @Published var appHoliday: String {
        didSet {
            UserDefaults.standard.set(appHoliday, forKey: "appHoliday")
        }
    }

    /// 表示に使用するカレンダー
    @Published var appCalendar: Calendar {
        didSet {
            UserDefaults.standard.set(appCalendar, forKey: "appCalendar")
        }
    }

    /// 週が始まる曜日 1:日 ... 7:土
    @Published var calendarStartingOn: Int {
        didSet {
            UserDefaults.standard.set(calendarStartingOn, forKey: "calendarStartingOn")
        }
    }
    
    /// カレンダーのマスの背景色
    @Published var calendarCellColorMon: Color {
        didSet {
            UserDefaults.standard.set(calendarStartingOn, forKey: "calendarCellColorMon")
        }
    }
    @Published var calendarCellColorTue: Color {
        didSet {
            UserDefaults.standard.set(calendarStartingOn, forKey: "calendarCellColorTue")
        }
    }
    @Published var calendarCellColorWed: Color {
        didSet {
            UserDefaults.standard.set(calendarStartingOn, forKey: "calendarCellColorWed")
        }
    }
    @Published var calendarCellColorThu: Color {
        didSet {
            UserDefaults.standard.set(calendarStartingOn, forKey: "calendarCellColorThu")
        }
    }
    @Published var calendarCellColorFri: Color {
        didSet {
            UserDefaults.standard.set(calendarStartingOn, forKey: "calendarCellColotFri")
        }
    }
    @Published var calendarCellColorSat: Color {
        didSet {
            UserDefaults.standard.set(calendarStartingOn, forKey: "calendarCellColorSat")
        }
    }
    @Published var calendarCellColorSun: Color {
        didSet {
            UserDefaults.standard.set(calendarStartingOn, forKey: "calendarCellColorSun")
        }
    }
    @Published var calendarCellColorToday: Color {
        didSet {
            UserDefaults.standard.set(calendarStartingOn, forKey: "calendarCellColorToday")
        }
    }
    @Published var calendarCellColorHighlight: Color {
        didSet {
            UserDefaults.standard.set(calendarStartingOn, forKey: "calendarCellColorHighlight")
        }
    }
    @Published var calendarCellColorSelected: Color {
        didSet {
            UserDefaults.standard.set(calendarStartingOn, forKey: "calendarCellColorSelected")
        }
    }

    // 絵のサイズ
    @Published var pictureSize: CGSize {
        didSet {
            UserDefaults.standard.set(pictureSize, forKey: "pictureSize")
        }
    }
    
    init() {
        self.appHoliday = UserDefaults.standard.value(forKey: "appHoliday") as? String ?? (Locale.current.regionCode ?? "")
        self.appCalendar = UserDefaults.standard.value(forKey: "appCalendar") as? Calendar ?? Calendar(identifier: .gregorian)
        self.calendarStartingOn = UserDefaults.standard.value(forKey: "calendarStartingOn") as? Int ?? 2
        self.pictureSize = UserDefaults.standard.value(forKey: "pictureSize") as? CGSize ?? CGSize(width: 2100.0, height: 1500.0)
        self.calendarCellColorMon = UserDefaults.standard.value(forKey: "calendarCellColorMon") as? Color ?? Color(red: 255/255, green: 250/255, blue: 205/255)
        self.calendarCellColorTue = UserDefaults.standard.value(forKey: "calendarCellColorTue") as? Color ?? Color(red: 255/255, green: 250/255, blue: 205/255)
        self.calendarCellColorWed = UserDefaults.standard.value(forKey: "calendarCellColorWed") as? Color ?? Color(red: 255/255, green: 250/255, blue: 205/255)
        self.calendarCellColorThu = UserDefaults.standard.value(forKey: "calendarCellColorThu") as? Color ?? Color(red: 255/255, green: 250/255, blue: 205/255)
        self.calendarCellColorFri = UserDefaults.standard.value(forKey: "calendarCellColorFri") as? Color ?? Color(red: 255/255, green: 250/255, blue: 205/255)
        self.calendarCellColorSat = UserDefaults.standard.value(forKey: "calendarCellColorSat") as? Color ?? Color(red: 255/255, green: 250/255, blue: 205/255)
        self.calendarCellColorSun = UserDefaults.standard.value(forKey: "calendarCellColorSun") as? Color ?? Color(red: 255/255, green: 192/255, blue: 203/255)
        self.calendarCellColorToday = UserDefaults.standard.value(forKey: "calendarCellColorToday") as? Color ?? Color(red: 135/255, green: 206/255, blue: 235/255)
        self.calendarCellColorHighlight = UserDefaults.standard.value(forKey: "calendarCellColorHighlight") as? Color ?? Color(red: 255/255, green: 160/255, blue: 122/255)
        self.calendarCellColorSelected = UserDefaults.standard.value(forKey: "calendarCellColorSelected") as? Color ?? Color(red: 152/255, green: 251/255, blue: 152/255)

    }
}
