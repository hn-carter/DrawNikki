//
//  NikkiPage.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/12/10.
//

import Foundation
import UIKit
import os

/// 絵日記の内容を操作する
struct NikkiPage {

    let logger = Logger(subsystem: "DrawNikki.NikkiPage", category: "NikkiPage")

    // 日記の日付
    var date: Date
    // 日記の絵
    var picture: UIImage?
    // 日記の文章
    var text: String?
    // 日記を保存しているファイル
    var file: NikkiFile

    var fileNumberDB: FileNumberRepository

    var nikkiDB: NikkiRepository
    
    init(date: Date, controller: PersistenceController) {
        self.date = date
        self.file = NikkiFile(controller: controller)
        self.fileNumberDB = FileNumberRepository(controller: controller)
        self.nikkiDB = NikkiRepository(controller: controller)
    }
    
    
    /// 日記にページを追加する
    func addNikkiPage() {
        
    }
    
    /// 日記のページを更新する
    func updateNikkiPage() {
        
    }
    
    /// 日記のページを削除する
    func deleteNikkiPage() {
        
    }
}
