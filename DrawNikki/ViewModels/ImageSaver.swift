//
//  ImageSaver.swift
//  DrawNikki
//
//  Created by hn-carter on 2022/01/25.
//

import UIKit

/// カメラロールへの保存時にエラーハンドリングを行うためのクラス
class ImageSaver: NSObject {
    // 成功時の処理
    var successHandler: (() -> Void)?
    // エラー時の処理
    var errorHandler: ((Error) -> Void)?
    
    /// カメラロールに画像を保存する
    /// - Parameter image: 保存するUIImage
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveComplete), nil)
    }

    /// 処理完了時の処理
    /// - Parameters:
    ///   - image: 画像
    ///   - error: 保存エラー
    ///   - contextInfo: 保存処理から渡されたデータへのポインタ
    @objc func saveComplete(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            errorHandler?(error)
        } else {
            successHandler?()
        }
    }
}
