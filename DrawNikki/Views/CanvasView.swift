//
//  CanvasView.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/11/21.
//

import SwiftUI
import UIKit
import PencilKit
import os

struct CanvasView: UIViewRepresentable {
    
    let logger = Logger(subsystem: "DrawNikki.CanvasView", category: "CanvasView")

    // 描画View
    @Binding var canvasView: PKCanvasView
    // 描画ペン
    @Binding var pen: PKInkingTool.InkType
    // 描画色
    @Binding var penColor: UIColor
    // 描画するペンの太さ
    @Binding var penWidth: CGFloat
    //　描画領域サイズ
    @Binding var size: CGSize
    // true : 背景画像の設定する
    @Binding var changeBackImage: Bool
    // 背景画像
    @Binding var backImage: UIImage?

    @Binding var firstRun: Bool
    private let test: testClass = testClass()
    
    private class testClass  {
        public static let shared: testClass = testClass()
        
        var backImageView: UIImageView = UIImageView(image: nil)

        init() {
        }
    }

    /// 描画キャンバスを作成
    /// - Parameter context: <#context description#>
    /// - Returns: 描画UIView
    func makeUIView(context: Context) -> PKCanvasView {
        logger.info("CanvasView.makeUIView")

        // PKCanvasViewで作成するコンテンツのサイズを設定
        canvasView.contentSize = size
        // contentInsetはビューからの距離（余白）を設定
        canvasView.contentInset = UIEdgeInsets()
        // contentOffsetは左上角からのスクロール表示位置
        canvasView.contentOffset = CGPoint(x: 0, y: 0)
        
        // 複数の指での操作を有効にする
        canvasView.isMultipleTouchEnabled = true
        // サブビューが境界に影響されるか
        // true : サブビューはレシーバーの境界でクリップされる
        canvasView.clipsToBounds = true
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(pen, color: penColor, width: penWidth)

        // 拡大・縮小を無効にする
        canvasView.maximumZoomScale = 1.0
        // 最小サイズは画面に全体表示できるサイズ
        canvasView.minimumZoomScale = 1.0
        // 背景を表示するため透明にする
        canvasView.isOpaque = false
        canvasView.backgroundColor = .clear

        if firstRun {
            if backImage == nil {
                logger.info("backImage == nil \(canvasView.subviews.count)")

                testClass.shared.backImageView = UIImageView(image: self.defaultBackImage())
                self.backImage = self.defaultBackImage()
            } else {
                logger.info("backImage != nil \(canvasView.subviews.count), w x h = \(backImage!.size.width) x \(backImage!.size.height)")
                testClass.shared.backImageView = UIImageView(image: backImage)
            }
            // canvasViewの背景を設定
            canvasView.addSubview(testClass.shared.backImageView)
            canvasView.sendSubviewToBack(testClass.shared.backImageView)

            firstRun = false
        }
        logger.info("backImage == nil \(self.backImage == nil)")
        logger.info("test.backImageView.image == nil \(test.backImageView.image == nil)")

        return canvasView
    }
    
    /**
     キャンバスコントロールを更新
     */
    func updateUIView(_ canvasView: PKCanvasView, context: Context) {
        logger.info("CanvasView.updateUIView")

        // PKCanvasViewで作成するコンテンツのサイズを設定
        canvasView.contentSize = size
        
        // 描画ツールを設定
        canvasView.tool = PKInkingTool(pen, color: penColor, width: penWidth)
        let msg = String(format: "testClass.shared.backImageView = %p", testClass.shared.backImageView)
        logger.info("\(msg)")
    }
    
    /// キャンバスの背景画像を設定する
    /// - Parameter image: 表示する背景画像
    func setBackImage(image: UIImage) {
        self.backImage = image
    }
    
    /**
     Viewの背景画像
     */
    func defaultBackImage() -> UIImage {
        // 描画開始
        UIGraphicsBeginImageContext(size)
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
        // 背景を塗りつぶす
        let rect = CGRect(origin: CGPoint.zero, size: size)
        //context.setFillColor(CGColor(red: 230/255, green: 230/255, blue: 250/255, alpha: 1))
        context.setFillColor(CGColor(red: 255/255, green: 255/255, blue: 250/255, alpha: 1))
        context.fill(rect)
        /*
        // 縦横罫線を描画
        context.setLineWidth(1.0)
        context.setStrokeColor(UIColor.blue.cgColor)
        for x in stride(from: 0, to: size.width, by: 100) {
            context.move(to: CGPoint(x: x, y: 0))
            context.addLine(to: CGPoint(x: x, y: size.height))
            context.strokePath()
        }
        for y in stride(from: 0, to: size.height, by: 100) {
            context.move(to: CGPoint(x: 0, y: y))
            context.addLine(to: CGPoint(x: size.width, y: y))
            context.strokePath()
        }
         */
        // 描画結果を取得
        guard let resultImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        // UIGraphicsBeginImageContextからの描画操作をクリアする
        UIGraphicsEndImageContext()
        return resultImage
    }
}
