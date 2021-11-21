//
//  ContentView.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/11/14.
//

import SwiftUI

struct ContentView: View {
    @State var selectionTab: Int = 1
    
    var body: some View {
        TabView(selection: $selectionTab) {
            CalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                        .font(.caption)
                }
                .tag(0)
            DetailView()
                .tabItem {
                    Label("Page", systemImage: "book")
                        .font(.caption)
                }
                .tag(1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
