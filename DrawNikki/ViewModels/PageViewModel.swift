//
//  PageViewModel.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/11/24.
//

import Foundation
import SwiftUI
import PencilKit
import os


/// 日記のベージViewModel
class PageViewModel: ObservableObject {

    // true: 空白ページ
    @Published var isEmptyPage: Bool = true
    
    let logger = Logger(subsystem: "DrawNikki.PageViewModel", category: "PageViewModel")
    let cdController: PersistenceController

    // 絵を描く画面に渡すViewModel
    var drawingVM: DrawingViewModel?
    var colorChartVM: ColorChartViewModel?

    // 処理用絵日記データ
    // ファイル管理番号
    //var fileNumber: Int
    // 日記ページデータ
    var nikkiPagesModel: NikkiPageBundle
    var pageModel: NikkiPage
    
    // 表示用絵日記データ
    // 日付
    var diaryDate: Date
    // 絵
    @Published var picture: UIImage? = nil
    // 文章
    // 編集中文章
    @Published var writingText: String = ""
    // 保存文章
    var text: String = ""
    // 絵日記のページを保存するファイル
    //var file: NikkiFile
    
    // 前のページデータ有無
    
    // 次のページデータ有無
    
    // タイトル日付のフォーマット
    var dateTitleFormatter: DateFormatter
    // 曜日のフォーマット
    var dateWeekdayFormatter: DateFormatter

    
    /// プレビュー用
    init() {
        self.cdController = PersistenceController()
        self.nikkiPagesModel = NikkiPageBundle(controller: self.cdController)
        self.pageModel = NikkiPage(date: Date(), number: 0, controller: self.cdController)

        self.diaryDate = Date()
        self.picture = nil
        self.writingText = ""

        self.dateTitleFormatter = DateFormatter()
        self.dateTitleFormatter.dateStyle = .full
        self.dateTitleFormatter.timeStyle = .none
        
        self.dateWeekdayFormatter = DateFormatter()
        self.dateWeekdayFormatter.setLocalizedDateFormatFromTemplate("E")
    }
    
    
    /// 日記ページモデルを元に初期化
    /// - Parameter bundle: 日記ページをまとめたモデル
    /// - Parameter page: ページモデル
    init(bundle: NikkiPageBundle, page: NikkiPage) {
        self.cdController = PersistenceController()
        self.nikkiPagesModel = bundle
        self.pageModel = page

        self.diaryDate = page.date
        self.picture = page.picture
        self.writingText = page.text ?? ""

        self.dateTitleFormatter = DateFormatter()
        self.dateTitleFormatter.dateStyle = .full
        self.dateTitleFormatter.timeStyle = .none
        
        self.dateWeekdayFormatter = DateFormatter()
        self.dateWeekdayFormatter.setLocalizedDateFormatFromTemplate("E")
    }
    
    /*
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
     */
    
    func setCalendar(calendar: Calendar) {
        self.dateTitleFormatter.calendar = calendar
        self.dateWeekdayFormatter.calendar = calendar

    }
    
    /// タイトルに表示する日付文字列を返す
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
        logger.info("PageViewModel.createDrawingVM")
        if drawingVM == nil {
            drawingVM = DrawingViewModel(image: picture)
            colorChartVM = ColorChartViewModel(selectAction: drawingVM!.selectedColorChart)
        } else {
            drawingVM!.backImage = picture
            drawingVM!.canvasView.drawing = PKDrawing()
        }
    }
    
    /*
    func saveFileNumber() {
        // データ更新
        let fileNumberDB = FileNumberRepository(controller: cdController)
        
        let updateItem = FileNumberRecord(fileNumber: self.fileNumber)
        let ret = fileNumberDB.updateFileNumber(item: updateItem)
        if ret {
            logger.info("log fn.updateFileNumber = true")
        } else {
            logger.info("log fn.updateFileNumber = false")
        }
    }
     */
    
    
    /// 絵日記の絵をself.pictureに一時保存する
    func saveTemporarily() {
        logger.info("PageViewModel.saveTemporarily")
        // 絵の描画画面では以前描いた絵(self.picture)の上に
        // 別に描画する(drawingVM!.getUIImage())
        // 保存するには合成する必要がある
        var compPicture: UIImage
        // 描いた絵
        if let drawImage = drawingVM!.getUIImage() {
            if picture != nil {
                // 以前の絵がある場合は合成する
                compPicture = picture!.compositeImage(image: drawImage)
            } else {
                compPicture = drawImage
            }
        } else {
            logger.error("There is no picture to save.")
            return
        }
        self.picture = compPicture
    }
    
    /// 絵日記の絵だけをファイルに保存する
    func savePicture() {
        // 絵の描画画面では以前描いた絵(self.picture)の上に
        // 別に描画する(drawingVM!.getUIImage())
        // 保存するには合成する必要がある
        var compPicture: UIImage
        // 描いた絵
        if let drawImage = drawingVM!.getUIImage() {
            if picture != nil {
                // 以前の絵がある場合は合成する
                compPicture = picture!.compositeImage(image: drawImage)
            } else {
                compPicture = drawImage
            }
        } else {
            logger.error("There is no picture to save.")
            return
        }
        // 絵をファイル保存する
        pageModel.picture = compPicture
        if isEmptyPage {
            // 新規追加
            pageModel.addNikkiPage()
            isEmptyPage = false
        } else {
            // 更新
            pageModel.updateNikkiPage()
        }
        
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
    
    
    
    // 次ページへ移動
    /*
     表示ページデータは以下の変数にあるのでこれを更新しないといけない
     
     // 日記ページデータ
     var pageModel: NikkiPage
     
     次ページを取得する処理は
     Model の NikkiPageBundle.getNextPage

     これはこのViewModelにはない
     
     NikkiViewModelにあるのでこれを呼び出す必要がある
     
     
     
     */
    
    
}
