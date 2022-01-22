//
//  DrawNikkiApp.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/11/14.
//

import SwiftUI


@main
/// エントリーポイント
struct DrawNikkiApp: App {
    // アプリ全体で使用する値 アプリ実行時にここだけでインスタンスを作成する
    @StateObject private var nikkiManager = NikkiManager()

    @ObservedObject private var nikki: NikkiViewModel = NikkiViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(nikki: nikki)
                .environmentObject(self.nikkiManager)
            // 表示時にファイルからデータを読み込む
//            .onAppear {
//                nikki.load()
//                nikki.setTodayPage()
//            }

        }
    }
}
