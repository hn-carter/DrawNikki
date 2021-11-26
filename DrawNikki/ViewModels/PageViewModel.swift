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
    var drawingVM: DrawingViewModel
    var colorChartVM: ColorChartViewModel

    // 文章を書く画面に渡すViewModel
    
    // 絵日記データ
    // 日付
    var diaryDate: Date
    // 絵
    var picture: UIImage? = nil
    // 文章
    // 編集中文章
    @Published var writingText: String = ""
    // 編集前文章
    var text: String = ""
    
    // タイトル日付のフォーマット
    var dateTitleFormatter: DateFormatter
    // 曜日のフォーマット
    var dateWeekdayFormatter: DateFormatter
    
    init() {
        self.diaryDate = Date()

        self.dateTitleFormatter = DateFormatter()
        self.dateTitleFormatter.dateStyle = .full
        self.dateTitleFormatter.timeStyle = .none
        
        self.dateWeekdayFormatter = DateFormatter()
        self.dateWeekdayFormatter.setLocalizedDateFormatFromTemplate("E")

        self.drawingVM = DrawingViewModel()
        self.colorChartVM = ColorChartViewModel(selectAction: drawingVM.selectedColorChart)

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
 

    
    // 絵
    //var image: Image {
    //    Image()
    //}

    // 文章
    
    
}
