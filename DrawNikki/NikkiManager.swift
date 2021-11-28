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
    // アプリで使用するカレンダー
    @Published var calendar: Calendar = Calendar(identifier: .gregorian)
    
    // 絵のサイズ
    @Published var pictureSize: CGSize = CGSize(width: 2100.0, height: 1500.0)
}
