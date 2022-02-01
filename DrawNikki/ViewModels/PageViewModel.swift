//
//  PageViewModel.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/11/24.
//

import Foundation
import SwiftUI
import PencilKit
import Photos
import os

/// 日記のベージViewModel
class PageViewModel: ObservableObject {
    var nikkiManager: NikkiManager
    
    // true: 空白ページ
    @Published var isEmptyPage: Bool = true
    
    let logger = Logger(subsystem: "DrawNikki.PageViewModel", category: "PageViewModel")
    let cdController: PersistenceController

    // 絵を描く画面に渡すViewModel
    @Published var drawingVM: DrawingViewModel?
    @Published var colorChartVM: ColorChartViewModel?

    // カメラロールに保存で使用するアラート
    @Published var showCameraRollAlert: AlertItem? = nil

    // 処理用絵日記データ
    // 日記ページデータ操作Model
    var nikkiPagesModel: NikkiPageBundle
    // 表示している日記ページ
    var pageModel: NikkiPage? = nil
    
    // 表示用絵日記データ
    // 日付
    @Published var diaryDate: Date
    // 絵
    @Published var picture: UIImage? = nil
    // 文章
    @Published var text: String = ""
    
    @Published var abc: String = ""
    // タイトル日付のフォーマット
    var dateTitleFormatter: DateFormatter
    // 曜日のフォーマット
    var dateWeekdayFormatter: DateFormatter
    
    init() {
        logger.trace("PageViewModel.init()")
        self.nikkiManager = NikkiManager()
        self.cdController = PersistenceController()
        self.nikkiPagesModel = NikkiPageBundle(controller: self.cdController)
        //self.pageModel = NikkiPage(date: Date(), number: 0, controller: self.cdController)

        self.diaryDate = Date()
        self.picture = nil
        self.text = ""

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
    
    /// 指定日のページを読み込む
    /// - Parameter date: 日付
    func loadPage(date: Date) {
        diaryDate = date
        // 日記ページ読み込み
        nikkiPagesModel.loadNikkiPagesByYesterdayTodayTomorrow(date: date)
        pageModel = nikkiPagesModel.getCurrentPage()
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

        guard let page = pageModel else { return }
        picture = page.picture
        text = page.text ?? ""
        // ViewModelを再作成
        drawingVM = nil
        drawingVM = DrawingViewModel(image: picture)
        colorChartVM = nil
        colorChartVM = ColorChartViewModel(selectAction: drawingVM!.selectedColorChart)
    }
    
    /// 編集中のページを保存する
    func savePage() -> Bool {
        logger.trace("PageViewModel.savePage")
        
        if pageModel == nil { return false }
    
        // 保存する絵　= picture
        // 保存ファイル名　= pageModel.pictureFilename
        pageModel!.picture = self.picture
        // 保存する文章
        pageModel!.text = self.text
        // 保存実行
        if isEmptyPage {
            // 新規保存
            let ret = nikkiPagesModel.addPage(page: &pageModel!)
            if ret == false {
                logger.error("ページの追加に失敗")
                return false
            }
            isEmptyPage = false
        } else {
            // 上書き更新
            let ret = nikkiPagesModel.updatePage(page: &pageModel!)
            if ret == false {
                logger.error("ページの上書き更新に失敗")
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
        picture = pageModel!.picture
        text = pageModel!.text ?? ""
        // ViewModelを再作成
        drawingVM = nil
        drawingVM = DrawingViewModel(image: picture!)
        colorChartVM = nil
        colorChartVM = ColorChartViewModel(selectAction: drawingVM!.selectedColorChart)
    }
    
    /// 現在表示しているページを削除する
    func deletePage() -> Bool {
        logger.trace("PageViewModel.deletePage")
        if self.isEmptyPage{ return true }
        // ページを削除後同じ日の次のページ、又は前のページを表示する
        // ページがない場合は空白ページ表示する
        let ret = nikkiPagesModel.deletePage()
        if !ret == false {
            logger.error("ページの削除に失敗")
            return false
        }

        pageModel = nikkiPagesModel.getCurrentPage()
        picture = pageModel!.picture
        text = pageModel!.text ?? ""

        // ViewModelを再作成
        drawingVM = nil
        drawingVM = DrawingViewModel(image: pageModel!.picture)
        colorChartVM = nil
        colorChartVM = ColorChartViewModel(selectAction: drawingVM!.selectedColorChart)

        return true
    }
    
    
    func showCurrentPage() {
        logger.trace("PageViewModel.showCurrentPage")
        guard let page = pageModel else { return }
        // 現在読み込んだデータを表示設定
        self.diaryDate = page.date
        self.abc = diaryDate.toString()
        self.picture = page.picture
        self.text = page.text ?? ""
        self.isEmptyPage = (page.number == 0)
        // ViewModelを再作成
        drawingVM = nil
        drawingVM = DrawingViewModel(image: picture)
        colorChartVM = nil
        colorChartVM = ColorChartViewModel(selectAction: drawingVM!.selectedColorChart)
    }
    
    /// 前ページ表示
    func showPreviousPage() -> Date {
        logger.trace("PageViewModel.showPreviousPage")
        // 現在位置を前ページへ移動
        pageModel = nikkiPagesModel.getPreviousPage()
        guard let page = pageModel else { return Date() }
        self.diaryDate = page.date
        self.picture = page.picture
        self.text = page.text ?? ""
        self.isEmptyPage = (page.number == 0)
        // ViewModelを再作成
        drawingVM = nil
        drawingVM = DrawingViewModel(image: picture)
        colorChartVM = nil
        colorChartVM = ColorChartViewModel(selectAction: drawingVM!.selectedColorChart)
        
        return page.date
    }
    
    /// 次ページ表示
    func showNextPage() -> Date {
        logger.trace("PageViewModel.showNextPage")
        // 現在位置を次ページへ移動
        pageModel = nikkiPagesModel.getNextPage()
        guard let page = pageModel else { return Date() }
        self.diaryDate = page.date
        self.picture = page.picture
        self.text = page.text ?? ""
        self.isEmptyPage = (page.number == 0)
        // ViewModelを再作成
        drawingVM = nil
        drawingVM = DrawingViewModel(image: picture)
        colorChartVM = nil
        colorChartVM = ColorChartViewModel(selectAction: drawingVM!.selectedColorChart)

        return page.date
    }
    
    /// 空白ページを表示し新規作成できる様にする
    func showNewPage() {
        logger.trace("PageViewModel.showNewPage")
        if self.isEmptyPage{ return }
        // 空白の DrawingViewModel を作成し、空白の EditView を表示する
        pageModel = NikkiPage(date: self.diaryDate, number: 0, controller: self.cdController)
        self.diaryDate = pageModel!.date
        self.picture = nil
        self.text = ""
        self.isEmptyPage = true
        drawingVM = nil
        drawingVM = DrawingViewModel(image: nil)
        colorChartVM = nil
        colorChartVM = ColorChartViewModel(selectAction: drawingVM!.selectedColorChart)
    }
    
    /*
     カメラロールに出力する画像
     保存形式　png
     幅 2100 * 縦 3000
     +--------------------------+
     |   2022年 1月 1日 土曜日    |  200 fontSize: 100
     +--------------------------+
     |                           |
     |  ここに絵を貼り付け          | 1500
     |  幅 2100 * 縦 1500 pixcel |
     +--------------------------+
     |                          |
     |  ここに文章を貼り付け        | 1300
     |                          | fontSize: 80
     +--------------------------+
     *
     */
    
    
    /// カメラロールへのアクセス許可を判定し、許可されていれば保存を実行する
    func checkCameraRoll() {
        logger.trace("PageViewModel.checkCameraRoll")

        // カメラロールへのアクセス許可確認
        if checkPhotoLibraryAuthorization() {
            // 保存処理呼び出し
            saveCameraRoll()
        } else {
            guard let page = pageModel else { return }

            showCameraRollAlert =
                AlertItem(alert: Alert(title: Text("failedToSave"),
                                       message: Text("confirmSetting"),
                                       primaryButton: .default(Text("close"),
                                           action: {
                                               self.showCameraRollAlert = nil
                                           }),
                                       secondaryButton: .destructive(Text("Settings"),
                                           action: {
                    // 設定を変更したらアプリが再起動される
                    // 再起動後に戻ってこれる様に現在表示している日をUserDefaultsに保存
                    self.nikkiManager.showingPageDate = page.date
                    self.nikkiManager.showingPageNumber = page.number
                                               // 設定画面へ
                                               guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
                                                       return
                                                   }
                                                UIApplication.shared.open(settingsURL,
                                                   completionHandler: { (success) in
                                                })
                                               self.showCameraRollAlert = nil
                                            })
                                      ))
            return
        }
    }
    
    /// ページをカメラロールに出力する
    func saveCameraRoll() {
        logger.trace("PageViewModel.saveCameraRoll")

        // 保存するイメージ作成
        let size = CGSize(width: 2100.0, height: 3000.0)
        // 描画開始
        UIGraphicsBeginImageContext(size)
        guard let context: CGContext = UIGraphicsGetCurrentContext() else { return }
        // 背景を塗りつぶす
        let rect = CGRect(origin: CGPoint.zero, size: size)
        context.setFillColor(CGColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1))
        context.fill(rect)
        // 年月日
        let titleFont = UIFont(name: "HiraMinProN-W6",size: 100.0)
        let titleStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        let titleFontAttributes = [
            NSAttributedString.Key.font: titleFont,
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.paragraphStyle: titleStyle
        ]
        // テキストをdrawInRectメソッドでレンダリング
        let titleText = dateTitleFormatter.string(from: diaryDate)
        // 描画サイズを計算し中央に配置する
        let titleDrawingSize = titleText.size(withAttributes: titleFontAttributes as [NSAttributedString.Key : Any])
        let titleX: CGFloat = (2100.0 - titleDrawingSize.width) / 2.0
        let titleRect = CGRect(x: titleX, y: 50.0,
                               width: titleDrawingSize.width,
                               height: titleDrawingSize.height)

        titleText.draw(in: titleRect, withAttributes: titleFontAttributes as [NSAttributedString.Key : Any])

        // タイトルと絵の間に線を引く
        context.setLineWidth(2.0)
        let lineColor = CGColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
        context.setStrokeColor(lineColor)
        let titleFrom: CGPoint = CGPoint(x: 50.0, y: 175.0)
        let titleTo: CGPoint = CGPoint(x: 2050.0, y: 175.0)
        context.move(to: titleFrom)
        context.addLine(to: titleTo)
        context.strokePath()

        // 絵を貼り付ける
        if let pic = picture {
            let penRect = CGRect(x: 0.0,
                                 y: 200.0,
                                 width: pic.size.width,
                                 height: pic.size.height)
            pic.draw(in: penRect)
        }
        
        // 文章を貼り付ける
        // フォントサイズ
        let textFontSize: CGFloat = 80.0
        // 描画フォント
        let textFont = UIFont(name: "HiraMinProN-W3",size: textFontSize)
        // 行間隔を設定
        let textStyle = NSMutableParagraphStyle()
        textStyle.minimumLineHeight = textFontSize
        textStyle.maximumLineHeight = textFontSize
        textStyle.lineSpacing = textFontSize / 2.0

        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.paragraphStyle: textStyle
        ]
        // テキストをdrawInRectメソッドでレンダリング
        let textText = text
        let wt = textText.size(withAttributes: textFontAttributes as [NSAttributedString.Key : Any])
        logger.debug("Size of text w.h = \(wt.width), \(wt.height)")

        let textRect = CGRect(x: 50.0, y: 1750.0, width: 2000.0, height: 1200.0)
        
        textText.draw(in: textRect, withAttributes: textFontAttributes as [NSAttributedString.Key : Any])

        // 行間に線を引く
        var textY: CGFloat = 1750.0 + textFontSize * 1.2
        var textFrom: CGPoint = CGPoint(x: 50.0, y: 0.0)
        var textTo: CGPoint = CGPoint(x: 2050.0, y: 0.0)

        while textY < 3000.0 {
            textFrom.y = textY
            textTo.y = textY
            context.move(to: textFrom)
            context.addLine(to: textTo)
            context.strokePath()
            textY += textFontSize * 1.5
        }
        
        // Context に描画された画像を新しく設定
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
                
        // Context 終了
        UIGraphicsEndImageContext()

        // カメラロールに画像を保存
        let imageSaver = ImageSaver()
        imageSaver.successHandler = {
            let logger = Logger(subsystem: "ImageSaver.writeToPhotoAlbum", category: "successHandler")
            logger.debug("カメラロールに保存成功")
            self.showCameraRollAlert =
                AlertItem(alert: Alert(title: Text("saved"),
                                       message: Text("savedMessage")))
        }
        imageSaver.errorHandler = {
            let logger = Logger(subsystem: "ImageSaver.writeToPhotoAlbum", category: "errorHandler")
            logger.debug("カメラロールに保存失敗 \($0.localizedDescription)")
            self.showCameraRollAlert =
                AlertItem(alert: Alert(title: Text("saveFailed"),
                                       message: Text("saveFailedMessage")))
        }
        imageSaver.writeToPhotoAlbum(image: newImage)
    }
    
    
    func checkPhotoLibraryAuthorization() -> Bool {
        var result: Bool = false
        // PhotoLibraryへのアクセス許可有無
        if PHPhotoLibrary.authorizationStatus(for: .addOnly) != .authorized {
            // アクセス許可をアプリに付与するようにユーザーに促す
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
                if status == .denied {
                    // 拒否された
                    result = false
                } else {
                    // 許可された
                    result = true
                    // 保存処理
                    self.saveCameraRoll()
                }
            }
        } else {
            result = true
        }
        return result
    }
}
