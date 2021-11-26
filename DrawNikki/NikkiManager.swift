//
//  NikkiManager.swift
//  DrawNikki
//
//  Created by hn-carteron 2021/11/25.
//

import Foundation

/**
 アプリの設定項目を管理する
 */
class NikkiManager: ObservableObject {
    // アプリで使用するカレンダー
    @Published var calendar: Calendar = Calendar(identifier: .gregorian)
}
