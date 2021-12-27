//
//  DrawingViewModel.swift
//  DrawNikki
//
//  Created by hn-carteron 2021/11/22.
//

import Foundation
import SwiftUI
import PencilKit

class DrawingViewModel: ObservableObject {
   
    @Published var canvasView = PKCanvasView()
    @Published var selectedPen: PKInkingTool.InkType = .pen
    @Published var selectedColor: UIColor = UIColor.black
    @Published var selectedWidth: CGFloat = 15.0
    // 描画Canvasの表示倍率
    @Published var scaleValue: CGFloat = 1.0
    // 色選択ウインドウ表示フラグ
    @Published var showColorChart: Bool = false
    // true : 背景画像を更新する
    @Published var changeBackImage: Bool
    // 背景画像
    @Published var backImage: UIImage? = nil
    

    /// イニシャライザ
    /// - Parameter image: 背景画像（この上に描く）
    init(image: UIImage? = nil) {
        self.changeBackImage = image != nil ? true : false
        self.backImage = image
        //self.canvasView.drawing = PKDrawing()
    }
    
    func gete(size: CGSize) -> CGFloat {
        let w: CGFloat = UIScreen.main.bounds.width / size.width
        let h: CGFloat = (UIScreen.main.bounds.height - 150.0) / size.height
        return w < h ? w : h
    }
    
    
    /**
     色選択ウインドウの表示切り替え
     */
    func toggleColorChart() {
        showColorChart = !showColorChart
    }
    /**
     色選択ウインドウで色が選択された時の処理
     */
    func selectedColorChart(c: Color?) -> Void {
        if let color = c {
            selectedColor = UIColor(color)
            showColorChart = false
        }
    }
    
    // UIImageを返す
    func getUIImage() -> UIImage? {
        UIGraphicsBeginImageContext(canvasView.contentSize)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        // 背景画像と合成
        let rect = CGRect(origin: CGPoint.zero, size: canvasView.contentSize)
        if backImage == nil {
            // 白背景
            context.setFillColor(CGColor(red: 230/255, green: 230/255, blue: 250/255, alpha: 1))
            context.fill(rect)
        } else {
            context.draw(backImage!.cgImage!, in: rect)
        }
        // PKCanvasViewの描画画像を取得
        let canvasImage: CGImage = canvasView.drawing.image(from: rect, scale: 1.0).cgImage!
        context.draw(canvasImage, in: rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
    
    /*
     消去
     
     */
}
