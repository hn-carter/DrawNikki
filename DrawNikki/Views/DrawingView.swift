//
//  DrawingView.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/11/22.
//

import SwiftUI
import PencilKit

struct DrawingView: View {
    @Environment(\.undoManager) private var undoManager

    @ObservedObject var viewModel: DrawingViewModel
    
    // 画像描画サイズ
    let picSize = CGSize(width: 1920.0, height: 1080.0)
    var body: some View {
        NavigationView {
            VStack {
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
                
                HStack(spacing: 10.0) {
                    DrawToolView(viewModel: viewModel)
                }
                .padding()

            }
        }
    }
}

struct DrawingView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingView(viewModel: DrawingViewModel())
    }
}
