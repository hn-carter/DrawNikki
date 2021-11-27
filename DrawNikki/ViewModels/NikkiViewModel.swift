//
//  NikkiViewModel.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/11/25.
//

import Foundation
import SwiftUI

class NikkiViewModel: ObservableObject {
    @Published var pageVM: PageViewModel
    
    init() {
        self.pageVM = PageViewModel()
    }
    
    func initialize() {
        
    }

    
    /// 今日の日付でPageViewModelを作成する
    /// 今日の日記がない場合は白紙ページとする
    func setTodayPage(pictureSize: CGSize) {
        pageVM = PageViewModel(picture: nil, pictureSize: pictureSize)
    }
    
    /// 日記データを読み込む
    func load() {
        
    }
    
    /// 日記データを保存する
    func save() {
        
    }

}
