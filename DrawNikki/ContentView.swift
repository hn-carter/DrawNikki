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
    
    @ObservedObject private var nikki: NikkiViewModel = NikkiViewModel()
    @State var selectionTab: Int = 1
    
    func initialize() {
        //nikki = NikkiViewModel()
        nikki.load()
        nikki.readFileNumber()
        nikki.setTodayPage()

    }
    
    
    var body: some View {
        //nikki.writeData(context: context)
        //nikki.getAllData()
        
        return TabView(selection: $selectionTab) {
            VStack {
                Text("優先度：\(nikki.fnumber)")
                    .fontWeight(.bold)
/*            CalendarView()
                .tabItem {
                    Label("calendar", systemImage: "calendar")
                        .font(.caption)
                }
 */
            }
            .tag(0)
                
            DetailView(pageViewModel: nikki.pageVM)
                .tabItem {
                    Label("page", systemImage: "book")
                        .font(.caption)
                }
                .tag(1)
        }
        // 表示時に日記データを読み込む
        .onAppear {
            print("ContentView.onAppear")
            initialize()
            //self.nikki = NikkiViewModel(settings: nikkiManager)
            //nikki.load()
            //nikki.setTodayPage()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(NikkiManager())
    }
}
