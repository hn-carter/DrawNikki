//
//  DrawingView.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/11/22.
//

import SwiftUI
import PencilKit

/**
 絵日記の絵を描く画面
 */
struct DrawingView: View {
    @Environment(\.undoManager) private var undoManager

    @ObservedObject var viewModel: DrawingViewModel
    @ObservedObject var colorViewModel: ColorChartViewModel
    
    // 画像描画サイズ
    let picSize = CGSize(width: 1920.0, height: 1080.0)
    var body: some View {
        NavigationView {
            ZStack {
                // 実際のアプリケーションの表示領域のサイズを取得
                // UIApplication.shared.keyWindow?.bounds
                    // PKCanvasViewを表示する
                CanvasView(canvasView: $viewModel.canvasView,
                           pen: $viewModel.selectedPen,
                           color: $viewModel.selectedColor,
                           width: $viewModel.selectedWidth,
                           size: viewModel.picSize)
                    .frame(width: UIScreen.main.bounds.width * (1.0 / viewModel.scaleValue), height: (UIScreen.main.bounds.height * 0.7) * (1.0 / viewModel.scaleValue))
                    .border(Color.blue, width: 3)
                    .scaleEffect(viewModel.scaleValue)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.7)
                    .padding(0)
                
                // 操作コントロール
                
                VStack(spacing: 10.0) {
                    Spacer()
                    DrawToolView(viewModel: viewModel, colorViewModel: colorViewModel)
                }
                
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct DrawingView_Previews: PreviewProvider {
    static var drawingVM = DrawingViewModel()
    static var colorChartVM = ColorChartViewModel(selectAction: drawingVM.selectedColorChart)
 
    static func kara(c: Color?) -> Void {}
    
    static var previews: some View {
        return Group {
            DrawingView(viewModel: drawingVM, colorViewModel: colorChartVM)
                .previewDevice("iPhone 12")
            DrawingView(viewModel: drawingVM, colorViewModel: colorChartVM)
                .previewDevice("iPad Air (4th generation)")
        }
    }
}
