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
        ZStack {
            VStack {
                Spacer()
                Capsule()
                    .fill(Color(red: 255/255, green: 250/255, blue: 205/255))
                    .frame(width:380, height: 50)
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
                        Image(systemName: "pencil.slash")
                    }
                    Button(action: { viewModel.selectedColor = UIColor.black })
                    { Image(systemName: "circle.fill")
                                .foregroundColor(Color.black) }
                    // 細いペン
                    Button(action: { viewModel.selectedWidth = 15.0 })
                    { Image(systemName: "scribble") }
                    // 太いペン
                    Button(action: { viewModel.selectedWidth = 60.0 })
                    { Image(systemName: "scribble")
                        .font(Font.title.weight(.bold))}
                    // 色選択ウインドウを表示する
                    Button(action: { viewModel.toggleColorChart() })
                    {
                            Image(systemName: "paintpalette.fill")
                            .foregroundColor(colorViewModel.selection ?? Color.blue)
                    }
                    // 全体表示
                    Button(action: { viewModel.scaleValue = viewModel.gete(size: nikkiManager.pictureSize) }) {
                        Image(systemName: "arrow.up.left.and.down.right.magnifyingglass")
                    }
                    Button(action: { viewModel.scaleValue -= 0.1 }) {
                        Image(systemName: "minus.magnifyingglass")
                    }
                    Button(action: { viewModel.scaleValue += 0.1 }) {
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
                            .frame(width: 250, height: 250)
                        ColorChartView(viewModel: colorViewModel)
                            .frame(width: 250, height: 250)
                    }
                    .padding(.bottom, 40.0)
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
