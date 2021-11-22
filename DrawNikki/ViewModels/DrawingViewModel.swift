//
//  DrawingViewModel.swift
//  DrawNikki
//
//  Created by hn-carteron 2021/11/22.
//

import Foundation
import PencilKit

class DrawingViewModel: ObservableObject {
   
    @Published var canvasView = PKCanvasView()
    @Published var selectedPen: PKInkingTool.InkType = .pen
    @Published var selectedColor: UIColor = UIColor.black
    @Published var selectedWidth: CGFloat = 15.0
    // 描画Canvasの表示倍率
    @Published var scaleValue: CGFloat = 1.0
    // 描画サイズ
    var picSize = CGSize(width: 1920.0, height: 1080.0)
    
    
    init() {
        
    }
    
    /*
     消去
     
     */
}
