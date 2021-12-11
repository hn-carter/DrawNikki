//
//  NikkiFile.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/12/09.
//

import Foundation
import CoreData
import os

/// 絵日記のファイルを扱う
struct NikkiFile {
    // CoreDataをカプセル化したコンテナ
    let container: NSPersistentContainer

    let logger = Logger(subsystem: "DrawNikki.NikkiFile", category: "NikkiFile")

    // 画像保存ファイル名
    var pictureFilename: String = ""
    // 文章保存ファイル名
    var textFilename: String = ""

    init(controller: PersistenceController) {
        self.container = controller.container
    }
    
    /*
     画像の保存
     文章の保存
     ファイル名の作成
     */
    
    
}
