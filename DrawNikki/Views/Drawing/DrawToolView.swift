//
//  DrawToolView.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/11/22.
//

import SwiftUI
import PencilKit

struct DrawToolView: View {
    @Environment(\.undoManager) private var undoManager
    @EnvironmentObject var nikkiManager: NikkiManager
    
    @ObservedObject var viewModel: DrawingViewModel
    @ObservedObject var colorViewModel: ColorChartViewModel
    
    var body: some View {
        // 画面幅によって表示サイズを調整
        // アイコンを並べる入れ物
        var containerWidth: CGFloat = 380.0
        var containerHeight: CGFloat = 50.0
        // 色選択ダイアログ
        var colorWidth: CGFloat = 250.0
        var colorHeight: CGFloat = 220.0
        if UIScreen.main.bounds.width < Constants.narrowScreenWidth {
            containerWidth = 320.0
            containerHeight = 50.0
            colorWidth = 210.0
            colorHeight = 210.0
        }

        return ZStack {
            VStack {
                Spacer()
                Capsule()
                    .fill(Color(red: 255/255, green: 250/255, blue: 205/255, opacity: 0.8))
                    .frame(width: containerWidth, height: containerHeight)
            }
            
            VStack {
                Spacer()
                HStack(spacing: 10.0) {

                    Button(action: { undoManager?.undo() }) {
                        Image(systemName: "arrow.uturn.left")
                    }
                    Button(action: { undoManager?.redo() }) {
                        Image(systemName: "arrow.uturn.right")
                    }
                    // 修正液　消去ではなく白のペンで塗りつぶす
                    Button(action: { viewModel.selectedColor = UIColor.white }) {
                        Image("eraser")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32.0)
                            .foregroundColor(Color.blue)
                    }
                    Button(action: { viewModel.selectedColor = UIColor.black })
                    { Image(systemName: "circle.fill")
                                .foregroundColor(Color.black) }
                    // 細いペン
                    Button(action: { viewModel.selectedWidth = 15.0 })
                    { Image(systemName: "scribble") }
                    // 太いペン
                    Button(action: { viewModel.selectedWidth = 300.0 })
                    { Image(systemName: "scribble")
                        .font(Font.title.weight(.bold))}
                    // 色選択ウインドウを表示する
                    Button(action: { viewModel.toggleColorChart() })
                    {
                            Image(systemName: "paintpalette.fill")
                            .foregroundColor(colorViewModel.selection)
                    }
                    // 全体表示
                    Button(action: { viewModel.scaleValue = viewModel.entireDisplay(size: nikkiManager.pictureSize) }) {
                        Image(systemName: "arrow.up.left.and.down.right.magnifyingglass")
                    }
                    Button(action: { viewModel.scaleValue = viewModel.reduceDisplay(size: nikkiManager.pictureSize) }) {
                        Image(systemName: "minus.magnifyingglass")
                    }
                    Button(action: { viewModel.scaleValue = viewModel.enlargeDisplay(size: nikkiManager.pictureSize) }) {
                        Image(systemName: "plus.magnifyingglass")
                    }
                }
                .padding(.bottom, 10.0)
            }
            if viewModel.showColorChart {
                VStack {
                    Spacer()
                    ZStack {
                        BubbleView(direction: BubbleView.BubbleShape.Direction.bottom)
                            .frame(width: colorWidth, height: colorHeight)
                        ColorChartView(viewModel: colorViewModel)
                            .frame(width: colorWidth, height: colorHeight)
                    }
                    .padding(.bottom, 35.0)
                    .offset(x: 50, y: 0)
                }
            }
        }

    }
}

struct DrawToolView_Previews: PreviewProvider {
    static func kara(c: Color?) -> Void {}
    
    static var previews: some View {
        DrawToolView(viewModel: DrawingViewModel(),
                     colorViewModel: ColorChartViewModel(selectAction: kara))
            .environmentObject(NikkiManager())
    }
}
