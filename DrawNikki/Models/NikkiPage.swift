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
    // 日記CoreData
    var nikkiRecord: NikkiRecord?

    var fileNumberDB: FileNumberRepository

    var nikkiDB: NikkiRepository
    
    
    /// 空のページを初期化する
    /// - Parameters:
    ///   - date: 日付
    ///   - number: ページ番号
    ///   - controller: CoreData用
    init(date: Date, number: Int = 0, controller: PersistenceController) {
        self.date = date
        self.number = number
        self.nikkiRecord = nil
        self.fileNumberDB = FileNumberRepository(controller: controller)
        self.nikkiDB = NikkiRepository(controller: controller)
    }
    
    /// CoreDataから読み込んだ内容からページを初期化する
    /// - Parameters:
    ///   - nikkiRec: ページCoreData
    ///   - controller: CoreData用
    init(nikkiRec: NikkiRecord, controller: PersistenceController) {
        self.date = nikkiRec.date!
        self.number = nikkiRec.number
        self.nikkiRecord = nikkiRec
        self.fileNumberDB = FileNumberRepository(controller: controller)
        self.nikkiDB = NikkiRepository(controller: controller)
        
        let fn = NikkiFile(pictureFilename: nikkiRec.picture_filename,
                           textFilename: nikkiRec.text_filename)
        // 日記の絵を読み込む
        if nikkiRec.picture_filename != nil {
            self.picture = UIImage(contentsOfFile: fn.pictureFileUrl!.path)
        }
        // 日記の文章を読み込む
        if nikkiRec.text_filename != nil {
            if let contentText = self.readJSONData(url: fn.textFileUrl!) {
                self.text = contentText.Text
            }
        }
    }
    
    /// 日記にページを新規追加する
    /// - Returns: 処理結果
    mutating func addNikkiPage() -> Bool {
        logger.trace("NikkiPage.addNikkiPage()")
        // ファイルの番号を取得
        var fn = 1
        if let fnRec = fileNumberDB.getFileNumber() {
            fn = fnRec.fileNumber + 1
        }
        // ファイル操作オブジェクトを用意
        let file = NikkiFile(fileNumber: fn)
        logger.debug("画像ファイルの保存先: \(file.pictureFilename)")
        logger.debug("テキストファイルの保存先: \(file.textFilename)")

        // pictureをファイル保存
        if let pic = picture {
            let ret = file.savePicture(picture: pic)
            if !ret {
                return false
            }
        }
        // textをファイル保存
        if text != nil {
            if let outputData = createJSONData() {
                let ret = file.saveText(data: outputData)
                if !ret {
                    return false
                }
            }
        }
        // この日の日記の最大ページ番号を取得
        var pageNum = nikkiDB.getMaxNumberOnDate(date: self.date)
        logger.info("この日の最大ベージ番号 = \(pageNum)")
        // CoreDataに保存するためにページ番号を1加算
        if pageNum <= 0 {
            pageNum = 1
        } else {
            pageNum += 1
        }
        // CoreDataに日記のページ情報を登録
        var newRec = NikkiRecord(number: pageNum)
        newRec.date = date
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
        // この日のページ番号を更新
        number = pageNum
        return true
    }
    
    /// 日記のページを更新する
    func updateNikkiPage() -> Bool {
        logger.trace("NikkiPage.updateNikkiPage()")

        guard let nr = nikkiRecord else { return false }
        // ファイル操作オブジェクトを用意
        let file = NikkiFile(pictureFilename: nr.picture_filename,
                             textFilename: nr.text_filename)
        logger.debug("画像ファイルの保存先: \(file.pictureFilename)")
        logger.debug("テキストファイルの保存先: \(file.textFilename)")

        // 画像ファイルを上書き保存
        if let pic = picture {
            let ret = file.savePicture(picture: pic)
            if !ret {
                return false
            }
        }
        // テキストファイルを上書き保存
        if text != nil {
            if let outputData = createJSONData() {
                let ret = file.saveText(data: outputData)
                if !ret {
                    return false
                }
            }
        }
        // CoreDataは更新日時のみ変更
        if nikkiDB.updateNikki(item: nr) == false {
            logger.error("Failed NikkiRepository.updateNikkiPage")
            return false
        }

        return true
    }
    
    /// 日記のページを削除する
    func deleteNikkiPage() -> Bool {
        logger.trace("NikkiPage.deleteNikkiPage()")

        guard let nr = nikkiRecord else { return false }
        // ファイル操作オブジェクトを用意
        let file = NikkiFile(pictureFilename: nr.picture_filename,
                             textFilename: nr.text_filename)

        // 画像ファイルを削除
        var ret = file.deletePictureFile()
        if !ret {
            return false
        }
        // テキストファイルを上書き保存
        ret = file.deleteTextFile()
        if !ret {
            return false
        }
        // CoreDataのレコードを削除する
        if nikkiDB.deleteNikki(item: nr) == false {
            logger.error("Failed NikkiRepository.updateNikkiPage")
            return false
        }

        return true
    }
    
    
    func createJSONData() -> Data? {
        let data = NikkiContent(Date: date.toString(), Text: text ?? "")
        
        let jsonData = try? JSONEncoder().encode(data)
        return jsonData
    }
    
    func readJSONData(url: URL) -> NikkiContent? {
        let fileData: Data?
        do {
            fileData = try Data(contentsOf: url)
        } catch {
            logger.error("Cannot read file: \(error.localizedDescription)")
            return nil
        }
        do {
            logger.debug("JSON file: \(url.absoluteString)")
            let json = try JSONDecoder().decode(NikkiContent.self, from: fileData!)
            logger.debug("JSON data date: \(json.Date), text: \(json.Text)")
            return json
        } catch {
            logger.error("Cannot decode JSON data: \(error.localizedDescription)")
            return nil
        }
    }
}
