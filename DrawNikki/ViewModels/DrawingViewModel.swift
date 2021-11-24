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
    // 描画サイズ
    var picSize = CGSize(width: 1920.0, height: 1080.0)
    
    
    init() {
        
    }
    
    /**
     色選択ウインドウの表示切り替え
     */
    func toggleColorChart() {
        self.showColorChart = !self.showColorChart
    }
    /**
     色選択ウインドウで色が選択された時の処理
     */
    func selectedColorChart(c: Color?) -> Void {
        if let color = c {
            self.selectedColor = UIColor(color)
            self.showColorChart = false
        }
    }
    
    /*
     消去
     
     */
}
