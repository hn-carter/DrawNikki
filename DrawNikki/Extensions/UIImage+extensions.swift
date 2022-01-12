//
//  UIImage+extensions.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/12/15.
//

import Foundation
import SwiftUI

extension UIImage {
    
    /// 指定した色で塗りつぶしたイメージで作成する
    /// - Parameter color: UIColor 塗りつぶす色
    /// - Parameter size: CGSize 作成するUIImageのサイズ
    convenience init?(color: UIColor, size: CGSize) {
        let rect = CGRect(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }

    /// 画像を合成する
    /// - Parameter image: 上に重ねる画像
    /// - Returns: 結果
    func compositeImage(image: UIImage) -> UIImage {
        var compositeImage: UIImage!
        UIGraphicsBeginImageContext(self.size)
        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        image.draw(in: rect)
        compositeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return compositeImage
    }
    
    /// サイズ変更したUIImageを返す
    /// - Parameter scale: 倍率
    /// - Returns: 変更後UIImage
    func getResizeImage(scale: CGFloat) -> UIImage? {
        let size = CGSize(width: self.size.width * scale, height: self.size.height * scale)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let rect = CGRect(origin: CGPoint.zero, size: size)
        self.draw(in: rect)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }

}
