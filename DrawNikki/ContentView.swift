//
//  ContentView.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/11/14.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var nikkiManager: NikkiManager
    // managedObjectContextデータ利用のための、＠Environmentの変数定義
    //@Environment(\.managedObjectContext) var context
    
    @ObservedObject var nikki: NikkiViewModel
    @State var selectionTab: Int = 1
    
    var body: some View {
        return TabView(selection: $selectionTab) {
            CalendarView()
                .tag(0)
                .tabItem {
                    Label("calendar", systemImage: "calendar")
                        .font(.caption)
                }

            DetailView(pageViewModel: nikki.pageVM!)
                .tag(1)
                .tabItem {
                    Label("page", systemImage: "book")
                        .font(.caption)
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(nikki: NikkiViewModel())
            .environmentObject(NikkiManager())
    }
}
