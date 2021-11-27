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
    @StateObject private var nikkiManager = NikkiManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(self.nikkiManager)
        }
    }
}
