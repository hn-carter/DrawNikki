//
//  EditView.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/11/24.
//

import SwiftUI

/// 絵日記の編集画面
struct EditView: View {
    @EnvironmentObject var nikkiManager: NikkiManager
    @ObservedObject var viewModel: PageViewModel
    // 画面の向きを設定
    @State private var orientation = UIDeviceOrientation.unknown
    // 絵を描く画面を表示
    @State private var showDrawing: Bool = false
    
    init(pageViewModel: PageViewModel) {
        self.viewModel = pageViewModel
    }

    var body: some View {

        VStack {
            // 年月日
            Text(viewModel.dateTitleString)
                .font(.title)
            .fixedSize(horizontal: false, vertical: true)
            // 日記の絵 タップで絵を描く画面へ
                if viewModel.picture == nil {
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .foregroundColor(.blue)
                        .padding(20)
                        .onTapGesture(perform: {
                            // 絵を描くViewへ渡すViewModelを用意
                            viewModel.createDrawingVM()
                            showDrawing = true
                        })
                        .frame(width: 300, height: 300)
                } else {
                    Image(uiImage: viewModel.picture!)
                        .resizable()
                        .padding()
                        .onTapGesture(perform: {
                            // 絵を描くViewへ渡すViewModelを用意
                            viewModel.createDrawingVM()
                            showDrawing = true
                            
                        })
                }

            // 日記の文章
            TextEditor(text: $viewModel.text)
                .font(.title)
                .overlay(RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.blue, lineWidth: 2))
                .padding(5)

        }
        // 余分なスペースができるのでタイトルを非表示
        .navigationBarTitle("writing", displayMode: .inline)
        // 絵を描くシートを表示
        .fullScreenCover(isPresented: $showDrawing) {
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
                VStack{
                    HStack {
                        // キャンセルボタン
                        //Button(action: {
                        //    showDrawing = false
                        //}) {Text("cancel")}
                        //.padding()
                        Spacer()
                        // 描画完了ボタン
                        Button(action: {
                            // 絵を一時保存
                            viewModel.saveTemporarily()
                            showDrawing = false
                        }) {Label("done", systemImage: "square.and.arrow.down")}
                        .padding()
                    }
                    DrawingView(viewModel: viewModel.drawingVM!,
                                colorViewModel: viewModel.colorChartVM!)
                }
            }
            // 回転時のイベント (カスタムモディファイア)
            .onRotate { newOrientation in
                orientation = newOrientation
            }
        }
        // iPadで画面全体に表示する
        .navigationViewStyle(.stack)

    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        return Group {
            EditView(pageViewModel: PageViewModel())
                .environmentObject(NikkiManager())
                .previewDevice("iPhone 12")
            EditView(pageViewModel: PageViewModel())
                .environmentObject(NikkiManager())
                .previewDevice("iPad Air (4th generation)")
        }
    }
}
