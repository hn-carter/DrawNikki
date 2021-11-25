//
//  ContentView.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/11/14.
//

import SwiftUI

struct ContentView: View {
    //@EnvironmentObject var nikkiManager: NikkiManager
    @ObservedObject private var nikki = NikkiViewModel()
    @State var selectionTab: Int = 1
    
    var body: some View {
        TabView(selection: $selectionTab) {
            CalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                        .font(.caption)
                }
                .tag(0)
            DetailView(pageViewModel: nikki.pageVM)
                //.environmentObject(self.nikkiManager)
                .tabItem {
                    Label("Page", systemImage: "book")
                        .font(.caption)
                }
                .tag(1)
        }
        // 表示時に日記データを読み込む
        .onAppear {
            nikki.load()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            //.environmentObject(NikkiManager())
    }
}
