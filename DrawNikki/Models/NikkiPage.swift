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
    // 同一日付内の番号
    var number: Int
    // 日記の絵
    var picture: UIImage?
    // 日記の文章
    var text: String?
    // 日記を保存しているファイル
    //var file: NikkiFile

    var fileNumberDB: FileNumberRepository

    var nikkiDB: NikkiRepository
    
    
    /// 空のページを初期化する
    /// - Parameters:
    ///   - date: <#date description#>
    ///   - number: <#number description#>
    ///   - controller: <#controller description#>
    init(date: Date, number: Int = 0, controller: PersistenceController) {
        self.date = date
        self.number = number
        self.fileNumberDB = FileNumberRepository(controller: controller)
        self.nikkiDB = NikkiRepository(controller: controller)
    }
    
    
    /// CoreDataから読み込んだ内容からページを初期化する
    /// - Parameters:
    ///   - nikkiRec: <#nikkiRec description#>
    ///   - controller: <#controller description#>
    init(nikkiRec: NikkiRecord, controller: PersistenceController) {
        self.date = nikkiRec.date!
        self.number = nikkiRec.number
        self.fileNumberDB = FileNumberRepository(controller: controller)
        self.nikkiDB = NikkiRepository(controller: controller)
        // 日記の絵を読み込む
        if let picPath = nikkiRec.picture_filename {
            self.picture = UIImage(named: picPath)
        }
        // 日記の文章を読み込む
        if let textPath = nikkiRec.text_filename {
            self.text = ""
        }
    }
    
    /// 日記にページを新規追加する
    /// - Returns: 処理結果
    func addNikkiPage() -> Bool {
        // ファイルの番号を取得
        var fn = 1
        if let fnRec = fileNumberDB.getFileNumber() {
            fn = fnRec.fileNumber + 1
        }
        // ファイル操作オブジェクトを用意
        let file = NikkiFile(fileNumber: fn)
        // pictureをファイル保存
        if let pic = picture {
            let ret = file.savePicture(picture: pic)
            if !ret {
                return false
            }
        }
        // textをファイル保存
        if let txt = text {
            
        }
        // この日の日記の最大ページ番号を取得
        var pageNum = nikkiDB.getMaxNumberOnDate(date: self.date)
        // CoreDataに保存するためにページ番号を1加算
        if pageNum <= 0 {
            pageNum = 1
        } else {
            pageNum += 1
        }
        // CoreDataに日記のページ情報を登録
        var newRec = NikkiRecord(number: pageNum)
        newRec.picture_filename = file.pictureFilename
        newRec.text_filename = file.textFilename
        if nikkiDB.createNikki(item: newRec) == false {
            logger.error("Failed NikkiRepository.createNikki")
            return false
        }
        // 追加したファイル番号をCoreDataに保存
        let updFnRec = FileNumberRecord(fileNumber: fn)
        if fileNumberDB.updateFileNumber(item: updFnRec) == false {
            logger.error("Failed FileNumberRepository.updateFileNumber")
            return false
        }

        return true
    }
    
    /// 日記のページを更新する
    func updateNikkiPage() {
        
    }
    
    /// 日記のページを削除する
    func deleteNikkiPage() {
        
    }
}
