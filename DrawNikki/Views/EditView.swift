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

    @State private var multiLine: String = "フンフンフフーン\nフンフフー\n\nTextEditorで複数行入力"
    // 絵を描く画面を表示
    @State private var showDrawing: Bool = false
    
    init(pageViewModel: PageViewModel) {
        self.viewModel = pageViewModel
    }

    var body: some View {
        // 絵を描くViewへ渡すViewModelを用意
        viewModel.createDrawingVM()

        //NavigationView {
        return VStack {
                // 年月日
                Text(viewModel.dateTitleString)
                    .font(.title)
                .fixedSize(horizontal: false, vertical: true)
                // 日記の絵
                /*
                Button(action: {
                    if viewModel.picture == nil {
                        
                    } else {
                        DrawingView(viewModel: viewModel.drawingVM, colorViewModel: viewModel.colorChartVM)
                    }
                }
                ) {
                    if viewModel.picture == nil {
                        Image(systemName: "square.and.pencil")
                            .resizable()
                            .padding(20)
                            //.frame(width: UIScreen.main.bounds.width, height: 300)
                    } else {
                        Image(uiImage: viewModel.picture!)
                            .resizable()
                            .padding()
                            //.frame(width: UIScreen.main.bounds.width, height: 300)
                    }
                }
                 */
/*
                NavigationLink(destination: DrawingView(viewModel: viewModel.drawingVM, colorViewModel: viewModel.colorChartVM)) {
                    if viewModel.picture == nil {
                        Image(systemName: "square.and.pencil")
                            .resizable()
                            .padding(20)
                            //.frame(width: UIScreen.main.bounds.width, height: 300)
                    } else {
                        Image(uiImage: viewModel.picture!)
                            .resizable()
                            .padding()
                            //.frame(width: UIScreen.main.bounds.width, height: 300)
                    }
                }
*/
            /*
                    NavigationLink(destination: DrawingView(viewModel: viewModel.drawingVM!,
                                                            colorViewModel: viewModel.colorChartVM!)) {
                        if viewModel.picture == nil {
                            Image(systemName: "square.and.pencil")
                                .resizable()
                                .padding(20)
                                //.onTapGesture(perform: { viewModel.createDrawingVM() })
                                //.frame(width: UIScreen.main.bounds.width, height: 300)
                        } else {
                            Image(uiImage: viewModel.picture!)
                                .resizable()
                                .padding()
                                //.frame(width: UIScreen.main.bounds.width, height: 300)
                        }
                    }
             */
                    if viewModel.picture == nil {
                        Image(systemName: "square.and.pencil")
                            .resizable()
                            .padding(20)
                            .onTapGesture(perform: { showDrawing = true })
                            .frame(width: 300, height: 300)
                    } else {
                        Image(uiImage: viewModel.picture!)
                            .resizable()
                            .padding()
                            .onTapGesture(perform: { showDrawing = true })
                    }

                // 日記の文章
                TextEditor(text: $viewModel.writingText)
                    .font(.title)
                    .padding()
            }
            // 余分なスペースができるのでタイトルを非表示
            .navigationBarTitle("writing", displayMode: .inline)
            .fullScreenCover(isPresented: $showDrawing) {
                NavigationView {
                DrawingView(viewModel: viewModel.drawingVM!,
                            colorViewModel: viewModel.colorChartVM!)
                    .navigationBarItems(leading: Button("Dismiss") {
                        showDrawing = false
                    },
                                        trailing: Button("Save") {
                        // 保存処理
                        showDrawing = false
                    })
                }
            }
            //.navigationBarTitle("")
            //.navigationBarHidden(true)
        //}
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
