//
//  UIImage+extensions.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/12/15.
//

import Foundation
import SwiftUI

extension UIImage {
    /// 画像を合成する
    /// - Parameter image: 上に重ねる画像
    /// - Returns: 結果
    func compositeImage(image: UIImage) -> UIImage {
        var compositeImage: UIImage!
        // Get the size of the first image.  This function assume all images are same size
        //let size: CGSize = CGSize(width: image.size.width, height: image.size.height)
        UIGraphicsBeginImageContext(self.size)
        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        image.draw(in: rect)
        compositeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return compositeImage
    }
}
