//
//  ColorChartViewModel.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/11/23.
//

import Foundation
import SwiftUI

class ColorChartViewModel: ObservableObject {
    
    let colors: [Color?] = [
        Color(red: 255/255, green: 255/255, blue: 255/255),
        Color(red: 192/255, green: 192/255, blue: 192/255),
        Color(red: 128/255, green: 128/255, blue: 128/255),
        Color(red: 0/255, green: 0/255, blue: 0/255),
        Color(red: 255/255, green: 0/255, blue: 0/255),
        Color(red: 128/255, green: 0/255, blue: 0/255),
        Color(red: 255/255, green: 255/255, blue: 0/255),
        Color(red: 128/255, green: 128/255, blue: 0/255),
        Color(red: 0/255, green: 255/255, blue: 0/255),
        Color(red: 0/255, green: 128/255, blue: 0/255),
        Color(red: 0/255, green: 255/255, blue: 255/255),
        Color(red: 0/255, green: 128/255, blue: 128/255),
        Color(red: 0/255, green: 0/255, blue: 255/255),
        Color(red: 0/255, green: 0/255, blue: 128/255),
        Color(red: 255/255, green: 0/255, blue: 255/255),
        Color(red: 128/255, green: 0/255, blue: 128/255)
    ]

    // 選択した色
    @Published var selection: Color? = nil
    
    init(selectAction: @escaping (Color?) -> Void) {
        //self._selection = colors[0]
        self.onSelected = selectAction
    }
    // 色選択時に実行する処理
    var onSelected: (Color?) -> Void
    /**
     色が選択されたときに呼び出す
     */
    func selectedColor(c: Color?) {
        selection = c
        onSelected(selection)
    }

}
