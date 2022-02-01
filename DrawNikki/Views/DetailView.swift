//
//  DetailView.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/11/21.
//

import SwiftUI
import os

/// 1ページの日記を表示する
struct DetailView: View {
    let logger = Logger(subsystem: "DrawNikki.DetailView", category: "DetailView")
    
    @EnvironmentObject var nikkiManager: NikkiManager
    @StateObject var nikki: NikkiViewModel
    @StateObject var pageViewModel: PageViewModel = PageViewModel()
    // 編集画面を表示
    @State private var showEditing: Bool = false
    // アラート表示
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    // 削除確認アラート
    @State private var showDeleteAlert: Bool = false
    // 画面の向きを設定
    @State private var orientation = UIDeviceOrientation.unknown

    // 画面初期処理
    func initialize() {
        logger.trace("DetailView.initialize")
        pageViewModel.setCalendar(calendar: nikkiManager.appCalendar)
        // 今日のページを設定
        logger.debug("nikki.selectedDate= \(nikki.selectedDate.toString())")
        pageViewModel.loadPage(date: nikki.selectedDate)
        pageViewModel.showCurrentPage()
    }
    
    var body: some View {
        ScrollView {
        VStack {
            //　回転の向き確認用
            if orientation.isPortrait {
                Text("Portrait")
                    .foregroundColor(Color.black.opacity(0.1))
            } else if orientation.isLandscape {
                Text("Landscape")
                    .foregroundColor(Color.black.opacity(0.1))
            } else if orientation.isFlat {
                Text("Flat")
                    .foregroundColor(Color.black.opacity(0.1))
            } else {
                Text("Unknown")
                    .foregroundColor(Color.black.opacity(0.1))
            }
            Text("\(pageViewModel.abc)")

            // 操作コントロール
            HStack(spacing: 20) {
                // 削除ボタン
                Button(action: {
                    // 確認する
                    showDeleteAlert = true
                }) {
                    Image(systemName: "trash")
                }
                .disabled(pageViewModel.isEmptyPage)
                .alert(isPresented: $showDeleteAlert, content: {
                    Alert(
                        title: Text("confirmDelete"),
                        primaryButton: .default(Text("yes"),
                                                action: {
                                                    showDeleteAlert = false
                                                    let _ = pageViewModel.deletePage()
                                                }),
                        secondaryButton: .destructive(Text("no"),
                                                      action: { showDeleteAlert = false })
                    )
                })

                Spacer()
                // カメラロールに保存Picture diary
                Button(action: {
                    pageViewModel.checkCameraRoll()
                    //pageViewModel.saveCameraRoll()
                }) {
                    // 画面幅が狭い時にはアイコンのみ表示する
                    if UIScreen.main.bounds.width < Constants.narrowScreenWidth {
                        Label("saveToCameraRoll", systemImage: "arrow.down.to.line.circle")
                            .labelStyle(IconOnlyLabelStyle())
                    } else {
                        Label("saveToCameraRoll", systemImage: "arrow.down.to.line.circle")
                    }
                }
                .disabled(pageViewModel.isEmptyPage)
                .alert(item: $pageViewModel.showCameraRollAlert) { item in
                    // セットされたAlert表示
                    item.alert
                }
                // 編集ボタン
                Button(action: {
                    showEditing = true
                }) {Label("edit", systemImage: "square.and.pencil")}
                .disabled(pageViewModel.isEmptyPage)

                // 追加ボタン
                Button(action: {
                    pageViewModel.showNewPage()
                    showEditing = true
                }) {Label("add", systemImage: "plus")}
            }
            .padding()
            
            Text(Locale.current.identifier)
            HStack(spacing: 20) {
                Spacer()
                // 年月日
                if UIScreen.main.bounds.width < Constants.narrowScreenWidth {
                    Text(pageViewModel.dateTitleString)
                        .font(.subheadline)
                } else {
                    Text(pageViewModel.dateTitleString)
                        .font(.title)
                }
                Spacer()
                // 前のページへ移動
                Button(action: {
                    nikki.selectedDate = pageViewModel.showPreviousPage()
                }) {Label("Previous", systemImage: "chevron.left").labelStyle(IconOnlyLabelStyle())}
                //　次のページへ移動
                Button(action: {
                    nikki.selectedDate = pageViewModel.showNextPage()
                }) {Label("Next", systemImage: "chevron.right").labelStyle(IconOnlyLabelStyle())}

            }
            .padding()
            // 絵
            if pageViewModel.picture == nil {
                Image(systemName: "square.and.pencil")
                    .resizable()
                    .scaledToFit()
                    .padding(20)
                    .frame(height: 300)
            } else {
                let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
                if orientation == .portrait ||
                    orientation == .portraitUpsideDown {
                Image(uiImage: pageViewModel.picture!)
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(width: UIScreen.main.bounds.width)
                } else {
                    Image(uiImage: pageViewModel.picture!)
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .frame(height: UIScreen.main.bounds.height * 0.7)
                }
            }
            
            // 文章
            if pageViewModel.text != "" {
                Text(pageViewModel.text)
                    .font(.title)
                    .frame(width: UIScreen.main.bounds.width - 10.0, alignment: .leading)
                    .padding(5)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 2))
            } else if pageViewModel.picture == nil {
                // この日の日記がない場合
                Text("noPageMessage")
                    .font(.title)
                    .foregroundColor(Color.gray)
                    .frame(width: UIScreen.main.bounds.width - 10.0, alignment: .center)
                    .padding(5)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 2))
            }
            Spacer()
        }
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .onAppear {
            logger.trace("DetailView.onAppear")
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
                            alertMessage = NSLocalizedString("failedToSave", comment: "")
                            showAlert = true
                        } else {
                            // ページ情報を再取得
                            pageViewModel.reloadPage()
                            showEditing = false
                        }
                    }) {
                        Label("save", systemImage: "square.and.arrow.down")
                            .labelStyle(.titleOnly)
                    }
                    .alert(isPresented: $showAlert, content: {
                                        Alert(title: Text(alertMessage))
                    })

                                        )
            }
        }
        // iPadで画面全体に表示する
        .navigationViewStyle(.stack)
        // 回転時のイベント (カスタムモディファイア)
        .onRotate { newOrientation in
            orientation = newOrientation
        }
    }
}
struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        return Group {
            DetailView(nikki: NikkiViewModel())
                .environmentObject(NikkiManager())
                .previewDevice("iPhone 12")
            DetailView(nikki: NikkiViewModel())
                .environmentObject(NikkiManager())
                .previewDevice("iPad Air (4th generation)")
        }
    }
}
