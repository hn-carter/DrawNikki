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
    @ObservedObject var pageViewModel: PageViewModel
    
    // 編集画面を表示
    @State private var showEditing: Bool = false
    // アラート表示
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
   
    // 画面初期処理
    func initialize() {
        pageViewModel.setCalendar(calendar: nikkiManager.calendar)
        showEditing = pageViewModel.isEmptyPage
    }
    
    var body: some View {
        VStack {
            // 操作コントロール
            HStack(spacing: 20) {
                // 削除ボタン
                Button(action: {
                    
                }) {
                    Image(systemName: "trash")
                }
                Spacer()
                // カメラロールに保存
                Button(action: {
                    
                }) {Label("saveToCameraRoll", systemImage: "arrow.down.to.line.circle")}

                // 編集ボタン
                Button(action: {
                    showEditing = true
                }) {Label("edit", systemImage: "square.and.pencil")}

                // 追加ボタン
                Button(action: {
                    
                }) {Label("add", systemImage: "plus")}

            }
            .padding()
            
            Text(Locale.current.identifier)
            HStack(spacing: 20) {
                Spacer()
                // 年月日
                Text(pageViewModel.dateTitleString)
                    .font(.title)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                // 前のページへ移動
                Button(action: {
                    pageViewModel.showPreviousPage()
                }) {Label("Previous", systemImage: "chevron.left").labelStyle(IconOnlyLabelStyle())}
                //　次のページへ移動
                Button(action: {
                    pageViewModel.showNextPage()
                }) {Label("Next", systemImage: "chevron.right").labelStyle(IconOnlyLabelStyle())}

            }
            .padding()
            // 絵
            if pageViewModel.picture == nil {
                Image(systemName: "square.and.pencil")
                    .resizable()
                    .padding(20)
                    //.frame(width: UIScreen.main.bounds.width, height: 300)
            } else {
                Image(uiImage: pageViewModel.picture!)
                    .resizable()
                    .scaledToFit()
                    .padding()
                    //.frame(width: UIScreen.main.bounds.width, height: 300)
            }
            
            // 文章
            Text(pageViewModel.text)
                .font(.title)
                .frame(width: UIScreen.main.bounds.width)
                .overlay(RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 2))
                .padding(5)
        }
        .onAppear {
            // イニシャライザ内でEnvironmentObjectを参照することができないので
            // 画面表示時に初期化処理を呼び出す
            self.initialize()
        }
        // 余分なスペースができるのでタイトルを非表示
        .navigationBarTitle("")
        .navigationBarHidden(true)
        //編集シートを表示
        .fullScreenCover(isPresented: $showEditing) {
            NavigationView {
                EditView(pageViewModel: pageViewModel)
                    .navigationBarItems(leading: Button("cancel") {
                        // 編集結果キャンセル処理
                        pageViewModel.cancelPage()
                        
                        showEditing = false
                    },
                    trailing: Button(action: {
                        // 編集結果保存処理
                        if pageViewModel.savePage() == false {
                            alertMessage = "failedToSave"
                            showAlert = true
                        } else {
                            // ページ情報を再取得
                            pageViewModel.reloadPage()
                            showEditing = false
                        }
                    }) {Label("save", systemImage: "square.and.arrow.down")}
                                        )
            }
        }
        .alert(isPresented: $showAlert, content: {
                            Alert(title: Text(alertMessage))
        })

        // iPadで画面全体に表示する
        .navigationViewStyle(.stack)
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
