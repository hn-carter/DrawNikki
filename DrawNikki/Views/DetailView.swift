//
//  DetailView.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/11/21.
//

import SwiftUI

/**
 1ページの日記を表示する
 追加ボタンで同じ日にページを追加
 絵をタップすると全画面表示
 絵の編集ボタンで描画画面へ遷移
 テキストを入力
 */
struct DetailView: View {
    @EnvironmentObject var nikkiManager: NikkiManager
    @ObservedObject var viewModel: PageViewModel
    
    /// イニシャライザ
    /// - Parameter pageViewModel: 1日分の絵日記ページ
    init(pageViewModel: PageViewModel) {
        self.viewModel = pageViewModel
    }
    
    // 画面初期処理
    func initialize() {
        viewModel.setCalendar(calendar: nikkiManager.calendar)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // ページが白紙なら編集Viewへ自動遷移する
                NavigationLink(destination: EditView(pageViewModel: viewModel),
                               isActive: $viewModel.isEmptyPage) {
                               EmptyView()
                }

                // 操作コントロール
                HStack(spacing: 20) {
                    Button(action: {
                        
                    }) {
                        Image(systemName: "trash")
                    }
                    Spacer()
                    // 編集
                    NavigationLink(destination: EditView(pageViewModel: viewModel)) {
                        Label("edit", systemImage: "square.and.pencil")
                    }
                    // 追加
                    Button(action: {
                        
                    }) {Label("add", systemImage: "plus")}

                }
                .padding()
                
                Text(Locale.current.identifier)
                HStack(spacing: 20) {
                    Spacer()
                    // 年月日
                    Text(viewModel.dateTitleString)
                        .font(.title)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                    Button(action: {
                        
                    }) {Label("Previous", systemImage: "chevron.left").labelStyle(IconOnlyLabelStyle())}
                    Button(action: {
                        
                    }) {Label("Next", systemImage: "chevron.right").labelStyle(IconOnlyLabelStyle())}

                }
                .padding()
                // 絵
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
                
                // 文章
                Text(viewModel.text)
                    .font(.title)
                    .padding(.leading)
                    //.frame(width: 500, height: 400)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 5))
            }
            .onAppear {
                // イニシャライザ内でEnvironmentObjectを参照することができないので
                // 画面表示時に初期化処理を呼び出す
                self.initialize()
            }
            // 余分なスペースができるのでタイトルを非表示
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
        // iPadで画面全体に表示する
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        return Group {
            DetailView(pageViewModel: PageViewModel())
                .environmentObject(NikkiManager())
                .previewDevice("iPhone 12")
            DetailView(pageViewModel: PageViewModel())
                .environmentObject(NikkiManager())
                .previewDevice("iPad Air (4th generation)")
        }
    }
}
