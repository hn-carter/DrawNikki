//
//  SettingListView.swift
//  DrawNikki
//
//  Created by hn-carter on 2022/02/04.
//

import SwiftUI

struct SettingListView: View {
    var body: some View {
        List {
            Text("プライバシーポリシー")
            Text("サポート")
        }
    }
}

struct SettingListView_Previews: PreviewProvider {
    static var previews: some View {
        SettingListView()
    }
}
