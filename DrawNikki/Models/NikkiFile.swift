//
//  NikkiFile.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/12/09.
//

import Foundation
import UIKit
//import CoreData
import os

/// 絵日記のファイルを扱う
struct NikkiFile {
    let logger = Logger(subsystem: "DrawNikki.NikkiFile", category: "NikkiFile")

    var fileNumber: Int = 0
    // 画像保存ファイルURL
    var pictureFileUrl: URL?
    var pictureFilename: String = ""
    var pictureFullPath: String {
        return self.pictureFileUrl == nil ? "" : self.pictureFileUrl!.absoluteString
    }
    // 文章保存ファイルURL
    var textFileUrl: URL?
    var textFilename: String = ""
    var textFullPath: String {
        return self.textFileUrl == nil ? "" : self.textFileUrl!.absoluteString
    }

    //init(controller: PersistenceController) {
    init(fileNumber: Int) {
        self.fileNumber = fileNumber
        createFilename()
    }
    init(pictureFilename: String?, textFilename: String?) {
        createFilename(pictureFn: pictureFilename, textFn: textFilename)
    }
    
    /*
     画像の保存
     文章の保存
     ファイル名の作成

     * アプリのデータフォルダを表示する
     xcrun simctl get_app_container booted com.todappg.DrawNikki data
     /Users/tanakahajime/Library/Developer/CoreSimulator/Devices/3156C050-0DDD-4FBA-B2AA-92F86C839665/data/Containers/Data/Application/C368CF27-B947-42F3-A04F-DD2F2666F4E2
     */

    /// データファイルを置くURLを表す
    private static var documentsFolder: URL? {
        do {
            // user’s Documents フォルダのURLを返す
            // FileManager.default : プロセスの共有ファイル管理オブジェクト
            // func url(
            //   for directory: FileManager.SearchPathDirectory, ドキュメントディレクトリ
            //   in domain: FileManager.SearchPathDomainMask, ユーザーのホームディレクトリ
            //   appropriateFor url: URL?, 使用しない (一時ディレクトリを使用するときのVolume ?)
            //   create shouldCreate: Bool ディレクトリを新規作成しない
            // ) throws -> URL
            return try FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: false)
        } catch {
            print("Can't find documents directory.")
        }
        return nil
    }
    
    
    /// 絵ファイルを置くURLを表す
    private static var picturesFolder: URL? {
        guard let docUrl = documentsFolder else { return nil }
        return docUrl.appendingPathComponent("pictures", isDirectory: true)
    }
    /// 文章ファイルを置くURLを表す
    private static var textsFolder: URL? {
        guard let docUrl = documentsFolder else { return nil }
        return docUrl.appendingPathComponent("texts", isDirectory: true)
    }
    
    func createDirectoryIfNeeded(url: URL) {
        if FileManager.default.fileExists(atPath: url.path) {
            logger.info("Directory exists: \(url.path)")
            return
        } else {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                logger.info("Directory created: \(url.path)")
            } catch {
                logger.error("Cannot create directory: \(url.path)")
            }
        }
    }

    mutating func createFilename(pictureFn: String? = nil, textFn: String? = nil) {
        // 画像ファイル名を作成
        guard let picFolder = NikkiFile.picturesFolder else { return }
        if let pfn = pictureFn {
            pictureFilename = pfn
        } else {
            pictureFilename = "np" + String(format: "%06d", self.fileNumber) + ".png"
        }
        pictureFileUrl = picFolder.appendingPathComponent(pictureFilename, isDirectory: false)
        
        // 文章ファイル名を作成
        guard let textFolder = NikkiFile.textsFolder else { return }
        if let tfn = textFn {
            textFilename = tfn
        } else {
            textFilename = "nt" + String(format: "%06d", self.fileNumber) + ".json"
        }
        textFileUrl = textFolder.appendingPathComponent(textFilename, isDirectory: false)
    }
    
    
    /// 画像をファイルに保存する
    /// - Parameter picture: 保存するイメージ
    /// - Returns: 処理結果
    func savePicture(picture: UIImage) -> Bool {
        guard let imageData = picture.pngData() else { return false }
        guard let picUrl = pictureFileUrl else { return false }
        if !checkPictureDirectory() {
            logger.error("Not exist picture directory")
            return false
        }
        do {
            try imageData.write(to: picUrl)
        } catch {
            logger.error("Cannot save picture: \(error.localizedDescription)")
            return false
        }
        return true
    }
    
    /// 画像ファイルを保存するディレクトリの存在チェックを行い、ない場合は作成する
    /// - Returns: true: 正常
    func checkPictureDirectory() -> Bool {
        guard let picFolder = NikkiFile.picturesFolder else { return false }
        createDirectoryIfNeeded(url: picFolder)
        return true
    }
    
    
    func saveText(text: String) -> Bool {
        guard let textUrl = textFileUrl else { return false }
        if !checkTextDirectory() {
            logger.error("Not exist text directory")
            return false
        }
        do {
            try text.write(to: textUrl, atomically: true, encoding: .utf8)
        } catch {
            logger.error("Cannot save text: \(error.localizedDescription)")
            return false
        }
        return true
    }

    func saveText(data: Data) -> Bool {
        guard let textUrl = textFileUrl else { return false }
        if !checkTextDirectory() {
            logger.error("Not exist text directory")
            return false
        }
        do {
            try data.write(to: textUrl)
        } catch {
            logger.error("Cannot save text: \(error.localizedDescription)")
            return false
        }
        return true
    }

    /// 文章ファイルを保存するディレクトリの存在チェックを行い、ない場合は作成する
    /// - Returns: true: 正常
    func checkTextDirectory() -> Bool {
        guard let textFolder = NikkiFile.textsFolder else { return false }
        createDirectoryIfNeeded(url: textFolder)
        return true
    }

}
