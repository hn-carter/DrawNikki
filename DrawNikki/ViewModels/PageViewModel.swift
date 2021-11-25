//
//  PageViewModel.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/11/24.
//

import Foundation
import SwiftUI

class PageViewModel: ObservableObject {
    var diaryDate: Date
    var picture: UIImage
    var text: String
    
    // タイトル日付のフォーマット
    var dateTitleFormatter: DateFormatter
    // 曜日のフォーマット
    var dateWeekdayFormatter: DateFormatter
    
    init() {
        self.diaryDate = Date()
        self.picture = UIImage()
        self.text = ""

        self.dateTitleFormatter = DateFormatter()
        //self.dateTitleFormatter.calendar = Calendar(identifier: .gregorian)
        self.dateTitleFormatter.locale = Locale.current
        self.dateTitleFormatter.dateStyle = .full
        self.dateTitleFormatter.timeStyle = .none
        
        self.dateWeekdayFormatter = DateFormatter()
        //self.dateWeekdayFormatter.calendar = Calendar(identifier: .gregorian)
        self.dateWeekdayFormatter.setLocalizedDateFormatFromTemplate("E")

        
    }
    
    func setCalendar(calendar: Calendar) {
        self.dateTitleFormatter.calendar = calendar
        self.dateWeekdayFormatter.calendar = calendar

    }
    // タイトルに表示する日付文字列を返す
    var dateTitleString: String {
        get {
            let s = self.dateTitleFormatter.string(from: self.diaryDate)
            //s.append(" ")
            //s.append(self.dateWeekdayFormatter.string(from: self.diaryDate))
            return s
        }
    }
    
    // 絵
    //var image: Image {
    //    Image()
    //}

    // 文章
    
    
}
