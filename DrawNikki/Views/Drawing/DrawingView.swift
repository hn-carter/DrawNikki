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
    @EnvironmentObject var nikkiManager: NikkiManager

    @ObservedObject var viewModel: DrawingViewModel
    @ObservedObject var colorViewModel: ColorChartViewModel
    
    @State private var orientation = UIDeviceOrientation.unknown
    
    var body: some View {
        ZStack {
            //　回転の向き確認用
            if orientation.isPortrait {
                Text("Portrait")
                    .foregroundColor(Color.black.opacity(0.0))
            } else if orientation.isLandscape {
                Text("Landscape")
                    .foregroundColor(Color.black.opacity(0.0))
            } else if orientation.isFlat {
                Text("Flat")
                    .foregroundColor(Color.black.opacity(0.0))
            } else {
                Text("Unknown")
                    .foregroundColor(Color.black.opacity(0.0))
            }
            // 背景
            Rectangle()
                .fill(Color.green)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .top)
                .ignoresSafeArea()
            // PKCanvasViewを表示する
            CanvasView(canvasView: $viewModel.canvasView,
                       pen: $viewModel.selectedPen,
                       penColor: $viewModel.selectedColor,
                       penWidth: $viewModel.selectedWidth,
                       size: $nikkiManager.pictureSize,
                       changeBackImage: $viewModel.changeBackImage,
                       backImage: $viewModel.backImage)
                .frame(width: UIScreen.main.bounds.width * (1.0 / viewModel.scaleValue), height: (UIScreen.main.bounds.height - 150.0) * (1.0 / viewModel.scaleValue))
                .border(Color.blue, width: 3)
                .scaleEffect(viewModel.scaleValue)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 150.0)
            
            // 操作コントロール
            VStack {
                Spacer()
                DrawToolView(viewModel: viewModel, colorViewModel: colorViewModel)
                    .padding(.bottom, 60)
            }
            .padding(.bottom)
            
            
        }
        // 回転時のイベント (カスタムモディファイア)
        .onRotate { newOrientation in
            orientation = newOrientation
        }
        // タイトルを小さく表示
        .navigationBarTitle("drawing", displayMode: .inline)
        .navigationViewStyle(.stack)
    }
}

struct DrawingView_Previews: PreviewProvider {
    static var drawingVM = DrawingViewModel()
    static var colorChartVM = ColorChartViewModel(selectAction: drawingVM.selectedColorChart)
 
    static func kara(c: Color?) -> Void {}
    
    static var previews: some View {
        Group {
            DrawingView(viewModel: drawingVM, colorViewModel: colorChartVM)
                .environmentObject(NikkiManager())
                .previewDevice("iPhone 12")
            DrawingView(viewModel: drawingVM, colorViewModel: colorChartVM)
                .environmentObject(NikkiManager())
                .previewDevice("iPad Air (4th generation)")
        }
    }
}
