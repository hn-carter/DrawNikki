//
//  ContentView.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/11/14.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var nikkiManager: NikkiManager
    
    @StateObject var nikki: NikkiViewModel
    //@State var selectionTab: Int = 1
    
    var body: some View {
        return TabView(selection: $nikki.selectionTab) {
            CalendarHostView(nikki: nikki)
                .tag(0)
                .tabItem {
                    Label("calendar", systemImage: "calendar")
                        .font(.caption)
                }

            DetailView(nikki: nikki)
                .tag(1)
                .tabItem {
                    Label("page", systemImage: "book")
                        .font(.caption)
                }
            SettingListView()
                .tag(2)
                .tabItem {
                    Label("settingsMenu", systemImage: "gearshape")
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
