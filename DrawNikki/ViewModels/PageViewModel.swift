//
//  PageViewModel.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/11/24.
//

import Foundation
import SwiftUI

class PageViewModel: ObservableObject {

    // true: 空白ページ
    @Published var isEmptyPage: Bool = true
    
    // 絵を描く画面に渡すViewModel
    var drawingVM: DrawingViewModel?
    var colorChartVM: ColorChartViewModel?

    // 文章を書く画面に渡すViewModel
    
    
    // 絵日記データ
    // 日付
    var diaryDate: Date
    // 絵
    var picture: UIImage? = nil
    // 画像サイズ
    var pictureSize: CGSize = CGSize()
    // 文章
    // 編集中文章
    @Published var writingText: String = ""
    // 保存文章
    var text: String = ""
    
    // タイトル日付のフォーマット
    var dateTitleFormatter: DateFormatter
    // 曜日のフォーマット
    var dateWeekdayFormatter: DateFormatter
    
    init(picture: UIImage? = nil, pictureSize: CGSize = CGSize()) {
        self.diaryDate = Date()

        self.dateTitleFormatter = DateFormatter()
        self.dateTitleFormatter.dateStyle = .full
        self.dateTitleFormatter.timeStyle = .none
        
        self.dateWeekdayFormatter = DateFormatter()
        self.dateWeekdayFormatter.setLocalizedDateFormatFromTemplate("E")
        
        self.picture = picture
        self.pictureSize = pictureSize
        
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
        
        drawingVM = DrawingViewModel(image: picture, imageSize: pictureSize)
        colorChartVM = ColorChartViewModel(selectAction: drawingVM!.selectedColorChart)

        
        print("PageViewModel.createDrawingVM")
    }
    
    // 絵
    //var image: Image {
    //    Image()
    //}

    // 文章
    
    
}
