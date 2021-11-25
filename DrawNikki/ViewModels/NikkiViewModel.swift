//
//  NikkiViewModel.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/11/25.
//

import Foundation

class NikkiViewModel: ObservableObject {
    @Published var pageVM: PageViewModel
    
    init() {
        self.pageVM = PageViewModel()
    }
    /**
     日記データを読み込む
     */
    func load() {
        
    }
    
    /**
     日記データを保存する
     */
    func save() {
        
    }

}
