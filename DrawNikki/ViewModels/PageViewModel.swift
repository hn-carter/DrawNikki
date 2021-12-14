//
//  PageViewModel.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/11/24.
//

import Foundation
import SwiftUI
import os

class PageViewModel: ObservableObject {

    // true: 空白ページ
    @Published var isEmptyPage: Bool = true
    
    let logger = Logger(subsystem: "DrawNikki.PageViewModel", category: "PageViewModel")
    let cdController: PersistenceController

    // 絵を描く画面に渡すViewModel
    var drawingVM: DrawingViewModel?
    var colorChartVM: ColorChartViewModel?

    // 絵日記データ
    // 日付
    var diaryDate: Date
    
    
    // 絵
    var picture: UIImage? = nil
    // 画像サイズ
    //var pictureSize: CGSize = CGSize()
    // 文章
    // 編集中文章
    @Published var writingText: String = ""
    // 保存文章
    var text: String = ""
    
    
    // 前のページデータ有無
    
    // 次のページデータ有無
    
    // タイトル日付のフォーマット
    var dateTitleFormatter: DateFormatter
    // 曜日のフォーマット
    var dateWeekdayFormatter: DateFormatter
    
    init(picture: UIImage? = nil) {
        self.cdController = PersistenceController()

        self.diaryDate = Date()

        self.dateTitleFormatter = DateFormatter()
        self.dateTitleFormatter.dateStyle = .full
        self.dateTitleFormatter.timeStyle = .none
        
        self.dateWeekdayFormatter = DateFormatter()
        self.dateWeekdayFormatter.setLocalizedDateFormatFromTemplate("E")
        
        self.picture = picture
        
        
    }
    
    func setCalendar(calendar: Calendar) {
        self.dateTitleFormatter.calendar = calendar
        self.dateWeekdayFormatter.calendar = calendar

    }
    /**
     タイトルに表示する日付文字列を返す
     */
    var dateTitleString: String {
        get {
            let s = self.dateTitleFormatter.string(from: self.diaryDate)
            return s
        }
    }
 

    
    // 新規画像作成　この日の絵を初めて書く場合の処理
    // DrawingView画面へ渡すViewModelを作成する
    //その時に画像サイズや背景などを設定する
    func createDrawingVM() -> Void {
        
        drawingVM = DrawingViewModel(image: picture)
        colorChartVM = ColorChartViewModel(selectAction: drawingVM!.selectedColorChart)

        
        print("PageViewModel.createDrawingVM")
    }
    
    
    // 絵日記の絵だけをファイルに保存する
    func savePicture() {
        // 絵を描く画面に渡したViewModelから画像を取得する
        //guard let vm = drawingVM else { return }
        //guard let picture = vm.getUIImage() else { return }
        /*
        // 保存するファイル名がない場合は画像と文章の保存ファイル名を求める
        if pictureFilename.count == 0 {
            var fnr = FileNumberRepository(controller: cdController)
            // ファイルにつける番号取得
            var number: Int
            if let fn = fnr.getFileNumber() {
                number = fn.fileNumber + 1
            } else {
                number = 1
            }
        }
        */
        // ファイルに保存
        
        // プロパティに絵を設定
        //self.picture = picture
    }
    
    // 絵日記の文章だけをファイルに保存する
    func saveText(text: String) {
        // ファイルに保存
        // プロパティに保存
        self.text = text
    }
    // 絵
    //var image: Image {
    //    Image()
    //}

    // 文章
    
    
}
