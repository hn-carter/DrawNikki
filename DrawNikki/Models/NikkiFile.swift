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
    // CoreDataをカプセル化したコンテナ
    //let container: NSPersistentContainer

    static let logger = Logger(subsystem: "DrawNikki.NikkiFile", category: "NikkiFile")

    var fileNumber: Int = 0
    // 画像保存ファイルURL
    var pictureFileUrl: URL?
    var pictureFilename: String {
        return self.pictureFileUrl == nil ? "" : self.pictureFileUrl!.absoluteString
    }
    // 文章保存ファイルURL
    var textFileUrl: URL?
    var textFilename: String {
        return self.textFileUrl == nil ? "" : self.textFileUrl!.absoluteString
    }

    //init(controller: PersistenceController) {
    init(fileNumber: Int) {
        //self.container = controller.container
        self.fileNumber = fileNumber
        createFilename()
    }
    init(pictureFilename: String, textFilename: String) {
        self.pictureFileUrl = URL(fileURLWithPath: pictureFilename)
        self.textFileUrl = URL(fileURLWithPath: textFilename)
    }
    
    /*
     画像の保存
     文章の保存
     ファイル名の作成
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
            logger.error("Can't find documents directory.")
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
            NikkiFile.logger.info("Directory exists: \(url.path)")
            return
        } else {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                NikkiFile.logger.info("Directory created: \(url.path)")
            } catch {
                NikkiFile.logger.error("Cannot create directory: \(url.path)")
            }
        }
    }

    mutating func createFilename() {
        // 画像ファイル名を作成
        guard let picFolder = NikkiFile.picturesFolder else { return }
        let pfn: String = "np" + String(format: "%06d", self.fileNumber) + ".jpg"
        pictureFileUrl = picFolder.appendingPathComponent(pfn, isDirectory: false)
        
        // 文章ファイル名を作成
        guard let textFolder = NikkiFile.textsFolder else { return }
        let tfn: String = "nt" + String(format: "%06d", self.fileNumber) + ".xml"
        textFileUrl = textFolder.appendingPathComponent(tfn, isDirectory: false)
    }
    
    
    /// イメージをファイルに保存する
    /// - Parameter picture: 保存するイメージ
    /// - Returns: 処理結果
    func savePicture(picture: UIImage) -> Bool {
        guard let imageData = picture.pngData() else { return false }
        guard let picUrl = pictureFileUrl else { return false }
        do {
            try imageData.write(to: picUrl)
        } catch {
            NikkiFile.logger.error("Cannot save picture: \(error.localizedDescription)")
            return false
        }
        return true
    }
    
}
