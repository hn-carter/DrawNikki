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
    @Published var drawingVM: DrawingViewModel?
    @Published var colorChartVM: ColorChartViewModel?

    // 編集中データ
    var editingData: NikkiData?
    
    // 処理用絵日記データ
    // 日記ページデータ Model
    var nikkiPagesModel: NikkiPageBundle
    var pageModel: NikkiPage
    
    // 表示用絵日記データ
    // 日付
    var diaryDate: Date
    // 絵
    @Published var picture: UIImage? = nil
    // 文章
    @Published var text: String = ""
    
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
        self.text = ""

        self.editingData = nil
        
        self.dateTitleFormatter = DateFormatter()
        self.dateTitleFormatter.dateStyle = .full
        self.dateTitleFormatter.timeStyle = .none
        
        self.dateWeekdayFormatter = DateFormatter()
        self.dateWeekdayFormatter.setLocalizedDateFormatFromTemplate("E")
        
        self.drawingVM = nil
        self.colorChartVM = nil
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
        self.text = page.text ?? ""

        if page.picture == nil && page.text == nil {
            // 空ページ
            self.isEmptyPage = true
            self.editingData = NikkiData(date: page.date)
        } else {
            self.isEmptyPage = false
            self.editingData = nil
        }
        
        self.dateTitleFormatter = DateFormatter()
        self.dateTitleFormatter.dateStyle = .full
        self.dateTitleFormatter.timeStyle = .none
        
        self.dateWeekdayFormatter = DateFormatter()
        self.dateWeekdayFormatter.setLocalizedDateFormatFromTemplate("E")

        self.drawingVM = nil
        self.colorChartVM = nil
    }
    
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
        logger.trace("PageViewModel.createDrawingVM")
        if drawingVM == nil {
            drawingVM = DrawingViewModel(image: self.picture)
            colorChartVM = ColorChartViewModel(selectAction: drawingVM!.selectedColorChart)
        } else {
            logger.debug("drawingVM!.backImage = picture == nil \(self.picture == nil)")
        }
    }
    
    /// 編集をキャンセルし元の状態に戻す
    func cancelPage() {
        logger.trace("PageViewModel.cancelPage")
        
        self.picture = pageModel.picture
        self.text = pageModel.text ?? ""
    }
    
    /// 編集中のページを保存する
    func savePage() -> Bool {
        logger.trace("PageViewModel.savePage")
        
        // 保存する絵　= picture
        // 保存ファイル名　= pageModel.pictureFilename
        pageModel.picture = self.picture
        // 保存する文章
        pageModel.text = self.text
        // 保存実行
        if isEmptyPage {
            // 新規保存
            let ret = pageModel.addNikkiPage()
            if ret == false {
                logger.error("ページの新規保存に失敗 pageModel.addNikkiPage()")
                return false
            }
            isEmptyPage = false
        } else {
            // 上書き更新
            let ret = pageModel.updateNikkiPage()
            if ret == false {
                logger.error("ページの上書き更新に失敗 pageModel.updateNikkiPage()")
                return false
            }
        }
        return true
    }
    
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
        drawingVM!.firstRun = false
    }
    
    /// 現在表示している日の日記のみリロードする
    func reloadPage() {
        logger.trace("PageViewModel.reloadPage")
        nikkiPagesModel.reloadNikkiPagesByToday()
        pageModel = nikkiPagesModel.getCurrentPage()
        // ViewModelを再作成
        drawingVM = nil
        drawingVM = DrawingViewModel(image: picture!)
        colorChartVM = nil
        colorChartVM = ColorChartViewModel(selectAction: drawingVM!.selectedColorChart)
    }
    
    
    /// 現在表示しているページを削除する
    func deletePage() {
        logger.trace("PageViewModel.deletePage")
        if self.isEmptyPage{ return }
        // ページを削除後同じ日の次のページ、又は前のページを表示する
        // ページがない場合は空白ページ表示する
        let ret = pageModel.deleteNikkiPage()
        
    }
    
    /// 前ページ表示
    func showPreviousPage() {
        logger.trace("PageViewModel.movePreviousPage")
        // 現在位置を前ページへ移動
        pageModel = nikkiPagesModel.getPreviousPage()
        self.diaryDate = pageModel.date
        self.picture = pageModel.picture
        self.text = pageModel.text ?? ""
        self.isEmptyPage = (pageModel.number == 0)
        // ViewModelを再作成
        drawingVM = nil
        drawingVM = DrawingViewModel(image: picture)
        colorChartVM = nil
        colorChartVM = ColorChartViewModel(selectAction: drawingVM!.selectedColorChart)
    }
    
    /// 次ページ表示
    func showNextPage() {
        logger.trace("PageViewModel.showNextPage")
        // 現在位置を次ページへ移動
        pageModel = nikkiPagesModel.getNextPage()
        self.diaryDate = pageModel.date
        self.picture = pageModel.picture
        self.text = pageModel.text ?? ""
        self.isEmptyPage = (pageModel.number == 0)
        // ViewModelを再作成
        drawingVM = nil
        drawingVM = DrawingViewModel(image: picture)
        colorChartVM = nil
        colorChartVM = ColorChartViewModel(selectAction: drawingVM!.selectedColorChart)
    }
    
    /// 空白ページを表示し新規作成できる様にする
    func showNewPage() {
        logger.trace("PageViewModel.showNewPage")
        if self.isEmptyPage{ return }
        // 空白の DrawingViewModel を作成し、空白の EditView を表示する
        pageModel = NikkiPage(date: self.diaryDate, number: 0, controller: self.cdController)
        self.diaryDate = pageModel.date
        self.picture = nil
        self.text = ""
        self.isEmptyPage = true
        drawingVM = nil
        drawingVM = DrawingViewModel(image: nil)
        colorChartVM = nil
        colorChartVM = ColorChartViewModel(selectAction: drawingVM!.selectedColorChart)
    }
}
