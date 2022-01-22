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

    // 絵のサイズ
    @Published var pictureSize: CGSize {
        didSet {
            UserDefaults.standard.set(pictureSize, forKey: "pictureSize")
        }
    }
    
    init() {
        self.appCalendar = UserDefaults.standard.value(forKey: "appCalendar") as? Calendar ?? Calendar(identifier: .gregorian)
        self.calendarStartingOn = UserDefaults.standard.value(forKey: "calendarStartingOn") as? Int ?? 2
        self.pictureSize = UserDefaults.standard.value(forKey: "pictureSize") as? CGSize ?? CGSize(width: 2100.0, height: 1500.0)
    }
}
